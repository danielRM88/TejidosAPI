module StateManager 
  extend ActiveSupport::Concern
  
  class TemplateError < RuntimeError; end

  include Stateful

  def save
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
        super
      # if the changes are not just in the state
      else
        # we create a duplicate of the record
        new_record = self.dup
        # reload the original one
        self.reload
        # update the original one to have state updated
        # since the record has dependencies, it is not
        # deletable
        self.change_state UPDATED_STATE
        # save the original one as updated
        super
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
        self.destroy
      else
        # otherwise it's just a regular update
        super
      end
    end
  end

  def destroy
    if self.count_dependencies > 0
      if self.get_state == CURRENT_STATE
        self.change_state DELETED_STATE
        self.save
      end
    else
      super
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