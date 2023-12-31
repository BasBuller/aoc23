parse_line(line) = split(line, ":")[2] |> x -> replace(x, " "=>"") |> x -> parse(Int, x)
function parse_input(path::String)
    input = open(path, "r") do file
        read(file, String)
    end
    lines = split(input, "\n")
    time, distance = parse_line(lines[1]), parse_line(lines[2])
    return (time, distance)
end


function get_win_ratios(duration::Int, best_distance::Int)
    hold, distance = 0, 0
    while distance <= best_distance
        hold += 1
        distance = (duration - hold) * hold
    end
    return duration - 2 * hold + 1
end


test_input = parse_input("day6_test.txt")
@show get_win_ratios(test_input...)
println()


test = parse_input("day6.txt")
@show get_win_ratios(test...)
