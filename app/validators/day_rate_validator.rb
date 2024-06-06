class DayRateValidator < ActiveModel::Validator
    def validate(record)
        if record.catch_amount.to_i != record.catch_amount && record.amount_type == "quantity"
            record.errors.add :base, I18n.t('errors.day_rate_validations')
        end
    end
end