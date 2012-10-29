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
  def to_s
    "audit"
  end
end