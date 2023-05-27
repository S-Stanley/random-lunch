require_relative "group"
require "test/unit"

class TestGroup < Test::Unit::TestCase

def test_is_user_already_in_lunch_function
    assert_equal(
        false,
        is_user_already_in_lunch(
            user_id="00",
            all_lunchs_yet_planned=[]
        )
    )

    assert_equal(
        true,
        is_user_already_in_lunch(
            user_id="00",
            all_lunchs_yet_planned=[Hash[
                "group" => "00",
                "with" => ["00"],
                "date" => Time.now.strftime("%d/%m/%Y"),
                "lunch_id" => 0
            ]]
        )
    )
end

end