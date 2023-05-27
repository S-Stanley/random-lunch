require 'json'

def get_groups()
    return JSON.parse(File.read('data/groups.json'))
end

GROUPS = get_groups()
$DEBUG = false

def get_members()
    return JSON.parse(File.read('data/group-members.json'))
end

def get_members_by_group_id(group_id)
    output = []
    all_members = get_members()
    for member in all_members do
        if member['group_id'] == group_id and member['active_today'] == true
            output.append(member['user_id'])
        end
    end
    return output
end

def is_user_already_in_lunch(user_id, all_lunchs_yet_planned)
    if all_lunchs_yet_planned.length == 0 or all_lunchs_yet_planned == nil
        return false
    end
    for lunch in all_lunchs_yet_planned
        if lunch['with'].include? user_id
            return true
        end
    end
    return false
end

def get_today_lunchs()
    lunch_id = 0
    output = []
    for group in GROUPS.shuffle() do
        members = get_members_by_group_id(group['id']).shuffle()
        lunch_members = []
        for member in members
            if not is_user_already_in_lunch(member, output)
                lunch_members.append(member)
            end
        end
            if lunch_members.length > 5
                for lunch_member_splited in lunch_members.each_slice(4).to_a do
                    if lunch_member_splited.length > 2
                        output.append(Hash[
                            "group" => group['id'],
                            "with" => lunch_member_splited,
                            "date" => Time.now.strftime("%d/%m/%Y"),
                            "lunch_id" => lunch_id
                        ])
                    end
                    lunch_id += 1
                end
            elsif
                if lunch_members.length > 2
                    output.append(Hash[
                        "group" => group['id'],
                        "with" => lunch_members,
                        "date" => Time.now.strftime("%d/%m/%Y"),
                        "lunch_id" => lunch_id
                    ])
                end
                lunch_id += 1
            end
    end
    return output
end

LUNCHS = get_today_lunchs()


for arg in ARGV
    if arg.split('=')[0] == 'debug' and arg.split('=')[1] == 'true'
        $DEBUG = true
    end
end
if $DEBUG
    for lunch in LUNCHS do
        puts lunch
    end
end