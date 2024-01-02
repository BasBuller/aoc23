card_order_1 = split("A, K, Q, J, T, 9, 8, 7, 6, 5, 4, 3, 2", ", ")
card_order_2 = split("A, K, Q, T, 9, 8, 7, 6, 5, 4, 3, 2, J", ", ")

@enum Rank five_of_a_kind four_of_a_kind full_house three_of_a_kind two_pair one_pair high_card
struct Hand{T<:AbstractString}
    cards::T
    counts::Dict{Char, Int}
    rank::Rank
    cards_rank::Vector{Int}
    bid::Int
end

function hand_rank_normal(n_counts::Int, max_count::Int)
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
    return rank
end

function hand_rank_1(unique_counts)
    max_count = values(unique_counts) |> maximum
    n_counts = length(unique_counts)
    return hand_rank_normal(n_counts, max_count)
end

function hand_rank_2(unique_counts)
    n_jokers = pop!(unique_counts, 'J', 0)
    n_counts = max(length(unique_counts), 1)
    max_count = maximum(values(unique_counts); init=0) + n_jokers
    return hand_rank_normal(n_counts, max_count)
end

function parse_input(path, card_order, rank_f)
    input = open(path, "r") do file
        read(file, String)
    end

    hands = []
    for hand in split(input, "\n")
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

        rank = rank_f(unique_counts)

        cards_rank = Int[]
        for card in cards
            card_rank = findfirst(x -> x == string(card), card_order)[1]
            push!(cards_rank, card_rank)
        end

        push!(hands, Hand(cards, unique_counts, rank, cards_rank, bid))
    end

    return hands
end

function get_answer(hands)
    hands = sort(hands; by=x -> (x.rank, x.cards_rank), rev=true)
    score = 0
    for (idx, hand) in enumerate(hands)
        score += idx * hand.bid
    end
    return score
end

test_hands_1 = parse_input("day7_test.txt", card_order_1, hand_rank_1)
@show get_answer(test_hands_1)
input_hands_1 = parse_input("day7.txt", card_order_1, hand_rank_1)
@show get_answer(input_hands_1)

test_hands_2 = parse_input("day7_test.txt", card_order_2, hand_rank_2)
@show get_answer(test_hands_2)
input_hands_2 = parse_input("day7.txt", card_order_2, hand_rank_2)
@show get_answer(input_hands_2)
