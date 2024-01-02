function parse_input(path::String)
    input = open(path, "r") do file
        read(file, String)
    end
    lines = split(input, "\n")

    instructions = lines[1]
    network = Dict()
    for node in lines[3:end]
        source, targets = split(node, " = ")
        targets_lut = Dict()
        for (instruction, rmatch) in zip(('L', 'R'), eachmatch(r"[A-Z]+", String(targets)))
            targets_lut[instruction] = String(rmatch.match)
        end
        network[String(source)] = targets_lut
    end
    
    return instructions, network
end

function part1(instructions, network) 
    current_node = "AAA"
    current_instruction_index = 1
    step_count = 0
    while current_node != "ZZZ"
        instruction = instructions[current_instruction_index]
        current_node = network[current_node][instruction]
        step_count += 1
        if current_instruction_index == length(instructions)
            current_instruction_index = 1
        else
            current_instruction_index += 1
        end
    end
    return step_count
end

instructions_test_1, network_test_1 = parse_input("day8_test_1.txt")
@show part1(instructions_test_1, network_test_1)
instructions_test_2, network_test_2 = parse_input("day8_test_2.txt")
@show part1(instructions_test_2, network_test_2)
instructions, network = parse_input("day8.txt")
@show part1(instructions, network)
