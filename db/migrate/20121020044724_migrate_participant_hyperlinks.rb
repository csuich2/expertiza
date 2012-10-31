class DataMigrate < ActiveRecord::Migration
  def self.up
    #part = Participant.new
    link = SubmittedContentLinks.new
    data = Participant.find_by_sql("select participants.id, participants.submitted_hyperlinks from participants")
    i=0
    size = data.length
    for i in 0..size-1
      #p data[i].attributes
      link.participant_id = data[i].attributes['id']
      link.hyperlink = data[i].attributes['submitted_hyperlinks']
      link.save
    end
    remove_column :participants, :submitted_hyperlinks
    end

  def self.down
    add_column :participants, :submitted_hyperlinks, :string
    part = Participant.new
    data = SubmittedContentLinks.find_by_sql("select submitted_content_links.participant_id, submitted_content_links.hyperlink from submitted_content_links")
    size = data.length
    hash = {}
    for i in 0..size-1
      p_id= data[i].attributes["participant_id"]
      h_link = data[i].attributes["hyperlink"]
      if h_link == nil
        next
      end
      if hash.has_key?(p_id)
        cat = hash[p_id] <<"--"<< h_link
        hash[p_id] = cat
      else
        hash[p_id] = h_link
      end
        end
    num = nil
    hash.each do |k,v|
      num = Participant.find_by_sql("select participants.id from participants where participants.id = #{k}")
       if num == nil
         part.id = k
        part.submitted_hyperlinks = v
         num = nil
        else
        #linkh = Participant.find_by_sql("select participants.submitted_hyperlinks from participants where participants.id = #{k}")
        #linkh[0].attributes["submitted_hyperlinks"] << "--" << v
        #p linkh[0].attributes["submitted_hyperlinks"]
        part1 = Participant.find(k)
        ##part1.update_attribute(:submitted_hyperlinks, linkh[0].attributes["submitted_hyperlinks"])
        part1.update_attribute(:submitted_hyperlinks, v)
        end
     part.save
    end

  end

end


