class Location < ApplicationRecord

  def age
    if self.created_at.localtime.is_a? Time
      createtime = self.created_at.localtime
      seconds = ((Time.now.localtime - createtime.localtime) % 60).round(0)
      minutes = (((Time.now.localtime - createtime.localtime) / 60) % 60).round(0)
      hours = (((Time.now.localtime - createtime.localtime) / 60) / 60).round(0)
    else
      return '<n/a>'
    end
    "#{hours}h #{minutes}m #{seconds}s"
  end

end
