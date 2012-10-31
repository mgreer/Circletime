class Audit < Audited::Adapters::ActiveRecord::Audit

  def auditable_object
    begin
      return auditable_type.classify.constantize.find(auditable_id)
    rescue
    end
  end

  def associated_object
    unless associated_type.nil?
      begin
        return associated_type.classify.constantize.find(associated_id)
      rescue
      end
    end
  end

  def self.by_class_and_action(classname, action, limit=20)
    @audits = Audit.order("id DESC").limit(limit)
    @audits = @audits.where( :auditable_type => classname ) if classname.present?
    @audits = @audits.where( :action => action )            if action.present?

    @audits
  end
  
  def to_s
    "audit"
  end
end