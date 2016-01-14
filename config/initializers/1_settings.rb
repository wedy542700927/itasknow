#encoding: utf-8
class Settings < Settingslogic
  source "#{Rails.root}/config/itask.yml"
  namespace Rails.env
end