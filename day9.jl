parse_line(line) = [parse(Int, num) for num in split(line)]
function parse_input(path::String)
    input = open(path, "r") do file
        read(file, String)
    end
    lines = [parse_line(line) for line in split(input, "\n")]
    return lines
end

diff(line::Vector{Int}) = [b - a for (a, b) in zip(line, line[2:end])]
function part1(lines::Vector{Vector{Int}})
    result = 0
    for line in lines
        result += line[end]
        while !all(line .== 0)
            line = diff(line)
            result += line[end]
        end
    end
    return result
end

function part2(lines::Vector{Vector{Int}})
    result = 0
    for line in lines
        line_res = line[1]
        multiplier = -1
        while !all(line .== 0)
            line = diff(line)
            line_res += multiplier * line[1]
            multiplier *= -1
        end
        result += line_res
    end
    return result
end

test_input = parse_input("day9_test.txt")
@show part1(test_input)
@show part2(test_input)

input = parse_input("day9.txt")
@show part1(input)
@show part2(input)
