const TimeDist = Tuple{Int, Int}
parse_line(line) = [parse(Int, x.match) for x in eachmatch(r"[0-9]+", line)]
function parse_input(path::String)
    input = open(path, "r") do file
        read(file, String) |> strip
    end
    lines = split(input, "\n")
    return zip(parse_line(lines[1]), parse_line(lines[2])) |> collect
end


distance(hold_duration::Int, race_duration::Int) = (race_duration - hold_duration) * hold_duration
function winning_ways(time_dist::TimeDist)
    wins = 0
    for hold in 1:time_dist[1]
        if distance(hold, time_dist[1]) > time_dist[2]
            wins += 1
        end
    end
    return wins
end
function part1(input::Vector{TimeDist})
    total_winning_ways = 1 
    for time_dist in input
        total_winning_ways *= winning_ways(time_dist)
    end
    return total_winning_ways
end


test_input = parse_input("day6_test.txt")
@show part1(test_input)
println()


input = parse_input("day6.txt")
@show part1(input)

