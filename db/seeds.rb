(1..8).each do |n|
  Grade.create(name: "#{n.ordinalize} Grade", priority: n)
end

Grade.create(name: 'High School', priority: 9)
Grade.create(name: 'College', priority: 10)

(1..7).each do |n|
  Tutorial.create page_name: "step_#{n}"
end

tutorials = Tutorial.all

users = User.all
users.each do |user|
  if user.user_tutorials.blank?
    tutorials.each do |tutorial|
      user.user_tutorials.create tutorial_id: tutorial.id, user_id: user.id
    end
  else
    next
  end
end

m1 = MailingList.create(name: 'pre-launch')
m1.users = User.all

Dev::Seeds.add_plans!
