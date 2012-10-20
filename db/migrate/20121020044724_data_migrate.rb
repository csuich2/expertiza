class DataMigrate < ActiveRecord::Migration
  def self.up
    #part = Participant.new
    link = SubmittedContentLinks.new
    data = Participant.find_by_sql("select participants.id, participants.submitted_hyperlinks from participants")
    i=0
    size = data.length
    for i in 0..size-1
      p data[i].attributes
      link.participant_id = data[i].attributes['id']
      link.hyperlink = data[i].attributes['submitted_hyperlinks']
      link.save
      i = i+1
     end
    end

  def self.down
  end
end
