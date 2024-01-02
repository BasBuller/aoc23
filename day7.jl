CARD_ORDER = split("A, K, Q, J, T, 9, 8, 7, 6, 5, 4, 3, 2", ", ")

@enum Rank five_of_a_kind four_of_a_kind full_house three_of_a_kind two_pair one_pair high_card
struct Hand{T<:AbstractString}
    cards::T
    counts::Dict{Char, Int}
    rank::Rank
    cards_rank::Vector{Int}
    bid::Int
end
function parse_hand(hand::T) where T<:AbstractString
    cards, bid = strip(hand) |> split
    bid = parse(Int, bid)

    unique_counts::Dict{Char, Int} = Dict()
    for card in cards
        if haskey(unique_counts, card)
            unique_counts[card] += 1
        else
            unique_counts[card] = 1
        end
    end
    
    max_count = values(unique_counts) |> maximum
    n_counts = length(unique_counts)
    if (n_counts == 1)
        rank = five_of_a_kind
    elseif (n_counts == 2) & (max_count == 4)
        rank = four_of_a_kind
    elseif (n_counts == 2) & (max_count == 3)
        rank = full_house
    elseif (n_counts == 3) & (max_count == 3)
        rank = three_of_a_kind
    elseif (n_counts == 3) & (max_count == 2)
        rank = two_pair
    elseif (n_counts == 4) & (max_count == 2)
        rank = one_pair
    elseif (n_counts == 5)
        rank = high_card
    else
        error("Invalid hand option")
    end

    cards_rank = Int[]
    for card in cards
        card_rank = findfirst(x -> x == string(card), CARD_ORDER)[1]
        push!(cards_rank, card_rank)
    end

    return Hand(cards, unique_counts, rank, cards_rank, bid)
end

function parse_input(path::String)
    input = open(path, "r") do file
        read(file, String)
    end
    return [parse_hand(hand) for hand in split(input, "\n")]
end

function part1(hands)
    hands = sort(hands; by=x -> (x.rank, x.cards_rank), rev=true)
    score = 0
    for (idx, hand) in enumerate(hands)
        score += idx * hand.bid
    end
    return score
end

test_hands = parse_input("day7_test.txt")
@show part1(test_hands)

input_hands = parse_input("day7.txt")
@show part1(input_hands)
