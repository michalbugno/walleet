require './lib/group_membership_manager'
require './lib/debt_adder'

class Migrator
  class Row < Struct.new(:new_row, :old_row)
  end

  attr_reader :tables, :users, :group_memberships, :debts

  def initialize(tables)
    @tables = tables
  end

  def migrate!
    migrate_users
    migrate_groups
    migrate_group_memberships
    migrate_debts
  end

  def migrate_users
    ActiveRecord::Base.transaction do
      Person.delete_all
      @users = tables["users"].map do |old|
        person = Person.new
        person.email = old.email
        person.created_at = old.created_at
        person.updated_at = old.updated_at
        person.encrypted_password = old.encrypted_password
        person.password = person.password_confirmation = "test123"
        person.save!
        Row.new(person, old)
      end
    end
  end

  def migrate_groups
    ActiveRecord::Base.transaction do
      Group.delete_all
      @groups = tables["groups"].map do |old|
        group = Group.new
        group.name = old.name
        group.created_at = old.created_at
        group.updated_at = old.updated_at
        group.currency_id = 1
        group.save!
        Row.new(group, old)
      end
    end
  end

  def migrate_group_memberships
    ActiveRecord::Base.transaction do
      GroupMembership.delete_all
      @group_memberships = tables["memberships"].map do |old|
        group_row = @groups.find { |row| row.old_row.id == old.group_id }
        if old.user_id
          person = @users.find { |row| row.old_row.id == old.user_id }.new_row
        else
          person = old.name
        end
        manager = GroupMembershipManager.new(group_row.new_row, person)
        manager.connect
        manager.membership.update_attributes(:created_at => old.created_at, :updated_at => old.updated_at)
        Row.new(manager.membership, old)
      end
    end
  end

  def migrate_debts
    ActiveRecord::Base.transaction do
      Debt.delete_all
      DebtElement.delete_all
      @debts = tables["debts"].map do |old|
        giver_row = group_memberships.find { |row| row.old_row.id == old.membership_id }
        if giver_row && !old.revoked
          old_debtors = tables["debt_entries"].select do |entry|
            entry.debt_id == old.id
          end
          old_giver = old_debtors.find { |e| e.amount > 0 }
          old_takers = old_debtors.select { |e| e.amount < 0 }
          taker_ids = old_takers.map(&:membership_id)
          takers = group_memberships.select do |row|
            taker_ids.include?(row.old_row.id)
          end
          takers.map! { |e| e.new_row }
          giver = group_memberships.find { |row| row.old_row.id == old_giver.membership_id }
          if giver && takers.size > 0
            debt_adder = DebtAdder.new(giver.new_row, takers, old.amount / 100.0, old.description)
            debt_adder.add_debt
            debt_adder.debt.update_attributes(:created_at => old.created_at, :updated_at => old.updated_at)
          else
            p "TAKERS EMPTY #{old}"
          end
        else
          p "NO GIVER #{old}" unless old.revoked
        end
      end
    end
  end
end
