require 'json'

def get_users
    return  JSON.parse(File.read("data/user.json"))
end

def get_friends
    return JSON.parse(File.read("data/friends.json"))
end

USERS = get_users()
FRIENDS = get_friends()
LUNCHS = []

def get_all_users_frienship(user_id)
    output = []
    for friend in FRIENDS do
        if friend['user_id'] == user_id
            output.append(friend)
        end
    end
    return output
end

def check_already_in_lunch_today(user_id)
    for lunch in LUNCHS do
        if LUNCHS.find(user_id)
            return true
        end
    end
    return false
end

for user in USERS.shuffle() do
    all_friends_user = get_all_users_frienship(user['id'])
    if all_friends_user.length > 0
        if not check_already_in_lunch_today(user['id'])
            LUNCHS.append({
                user_ids: [user['id'], all_friends_user.sample['with_user_id']],
                date: Time.now.strftime("%d/%m/%Y")

            })
        end
    end
end

for lunch in LUNCHS do
    puts lunch
end