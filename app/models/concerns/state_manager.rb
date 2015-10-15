module StateManager 
  extend ActiveSupport::Concern
  
  class TemplateError < RuntimeError; end

  CURRENT_STATE = 'CURRENT'
  UPDATED_STATE = 'UPDATED'
  DELETED_STATE = 'DELETED'

  attr_accessor :perform_update_check, :perform_delete_check

  included do
    before_update :check_update_dependencies, if: Proc.new { |model| model.perform_update_check != false }
    before_destroy :check_destroy_dependencies, if: Proc.new { |model| model.perform_delete_check != false }
  end

  # Validation that checks if the record
  # does not have dependencies and
  # therefore can be updated.
  def check_update_dependencies
    dependencies = count_dependencies
    if dependencies > 0
      return false
    end
  end

  # Validation that checks if the record
  # does not have dependencies and
  # therefore can be deleted.
  def check_destroy_dependencies
    dependencies = count_dependencies
    if dependencies > 0
      return false
    end
  end

  # Method that updates a record taking into 
  # consideration that it may have dependencies.
  # If the record has dependencies and it is not updated
  # through this method, the validations preventing the update
  # will take place.
  def update_record
    # we tell the validators to not perform validations on the dependencies
    # because we are taking the appropiate steps in this method
    self.perform_update_check = false
    # we check if the record has dependencies
    dependencies = count_dependencies
    # we check if the state of the record is beeing changed
    state_change = self.changes[get_state_field]
    
    if !state_change.blank?
      # further work required
      prev_state = state_change[0]
      final_state = state_change[1]
    end

    # if the record has dependencies (e.g. invoices or sales, etc...)
    if dependencies > 0
      # if the record is only changing states
      if self.changes.length == 1 && !final_state.blank?
        # if the state is not changing to deleted
        if final_state != DELETED_STATE
          self.save
        else
          # if it is then we delete the record
          destroy_record
        end
      # if the changes are not just in the state
      else
        # we create a duplicate of the record
        new_record = self.dup
        # reload the original one
        self.reload
        # update the original one to have state updated
        # since the record has dependencies, it is not
        # deletable
        change_state UPDATED_STATE
        # save the original one as updated
        self.save
        # and create a new record with the modified fields
        new_record.save
      end
    # if the record does not have dependencies
    # we are free to modify it as we like
    else
      # if the state is the only thing that is beeing modified
      # and is changed to deleted
      if self.changes.length == 1 && !final_state.blank? && final_state == DELETED_STATE
        # then we delete the record
        destroy_record
      else
        # otherwise it's just a regular update
        self.save
      end
    end
  end

  # Method that deletes a record taking into 
  # consideration that it may have dependencies.
  # If the record has dependencies and it is not deleted
  # through this method, the validations preventing the deletion
  # will take place.
  def destroy_record
    perform_delete_check = false    
    dependencies = count_dependencies
    if dependencies > 0
      change_state DELETED_STATE
      self.save
    else
      self.delete
    end
  end

  def current?
    return get_state == CURRENT_STATE
  end

  def count_dependencies
    raise TemplateError, "The StateManager module requires the including class to define a count_dependencies method"
  end

  def change_state
    raise TemplateError, "The StateManager module requires the including class to define a change_state method"
  end

  def get_state
    raise TemplateError, "The StateManager module requires the including class to define a get_state method"
  end

  def get_state_field
    raise TemplateError, "The StateManager module requires the including class to define a get_state_field method"
  end

end