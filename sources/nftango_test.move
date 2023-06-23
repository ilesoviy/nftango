module overmind::nftango_test {
    #[test_only]
    use aptos_framework::account;
    #[test_only]
    use aptos_token::token;
    #[test_only]
    use overmind::nftango::{initialize_game, assert_nftango_store_exists, cancel_game, assert_nftango_store_is_not_active, join_game, assert_nftango_store_has_an_opponent, play_game, claim};
    #[test_only]
    use std::signer;
    #[test_only]
    use std::string::String;
    #[test_only]
    use std::vector;

    //
    // Test functions
    // Searching == test_[function_name]_[success || failture]_[reason]
    //
    #[test(aptos_framework = @0x1, nft_owner = @0xCAFE, creator = @0x12)]
    fun test_initialize_game_success(
        aptos_framework: &signer,
        nft_owner: &signer,
        creator: &signer
    ) {
        let aptos_framework_address = signer::address_of(aptos_framework);
        let nft_owner_address = signer::address_of(nft_owner);
        let creator_address = signer::address_of(creator);

        account::create_account_for_test(aptos_framework_address);
        account::create_account_for_test(nft_owner_address);
        account::create_account_for_test(creator_address);

        token::opt_in_direct_transfer(creator, true);

        let token_id = token::create_collection_and_token(
            nft_owner,
            10,
            1,
            10,
            vector<String>[],
            vector<vector<u8>>[],
            vector<String>[],
            vector<bool>[false, false, false],
            vector<bool>[false, false, false, false, true],
        );

        let (nft_creator, nft_collection_name, nft_token_name, nft_property_version) = token::get_token_id_fields(
            &token_id
        );

        token::transfer(nft_owner, token_id, creator_address, 1);

        initialize_game(
            creator,
            nft_creator,
            nft_collection_name,
            nft_token_name,
            nft_property_version,
            1
        );

        assert_nftango_store_exists(creator_address);
        assert!(token::balance_of(creator_address, token_id) == 0, 0);
    }

    #[test(aptos_framework = @0x1, nft_owner = @0xCAFE, creator = @0x12)]
    #[expected_failure(abort_code = 0, location = overmind::nftango)]
    fun test_initialize_game_failure_nftango_already_exists(
        aptos_framework: &signer,
        nft_owner: &signer,
        creator: &signer
    ) {
        let aptos_framework_address = signer::address_of(aptos_framework);
        let nft_owner_address = signer::address_of(nft_owner);
        let creator_address = signer::address_of(creator);

        account::create_account_for_test(aptos_framework_address);
        account::create_account_for_test(nft_owner_address);
        account::create_account_for_test(creator_address);

        token::opt_in_direct_transfer(creator, true);

        let token_id = token::create_collection_and_token(
            nft_owner,
            10,
            1,
            10,
            vector<String>[],
            vector<vector<u8>>[],
            vector<String>[],
            vector<bool>[false, false, false],
            vector<bool>[false, false, false, false, true],
        );

        let (nft_creator, nft_collection_name, nft_token_name, nft_property_version) = token::get_token_id_fields(
            &token_id
        );

        token::transfer(nft_owner, token_id, creator_address, 1);

        initialize_game(
            creator,
            nft_creator,
            nft_collection_name,
            nft_token_name,
            nft_property_version,
            1
        );

        initialize_game(
            creator,
            nft_creator,
            nft_collection_name,
            nft_token_name,
            nft_property_version,
            1
        );
    }

    #[test(aptos_framework = @0x1, nft_owner = @0xCAFE, creator = @0x12)]
    fun test_cancel_game_success(
        aptos_framework: &signer,
        nft_owner: &signer,
        creator: &signer
    ) {
        let aptos_framework_address = signer::address_of(aptos_framework);
        let nft_owner_address = signer::address_of(nft_owner);
        let creator_address = signer::address_of(creator);

        account::create_account_for_test(aptos_framework_address);
        account::create_account_for_test(nft_owner_address);
        account::create_account_for_test(creator_address);

        token::opt_in_direct_transfer(creator, true);

        let token_id = token::create_collection_and_token(
            nft_owner,
            10,
            1,
            10,
            vector<String>[],
            vector<vector<u8>>[],
            vector<String>[],
            vector<bool>[false, false, false],
            vector<bool>[false, false, false, false, true],
        );

        let (nft_creator, nft_collection_name, nft_token_name, nft_property_version) = token::get_token_id_fields(
            &token_id
        );

        token::transfer(nft_owner, token_id, creator_address, 1);

        initialize_game(
            creator,
            nft_creator,
            nft_collection_name,
            nft_token_name,
            nft_property_version,
            1
        );

        assert_nftango_store_exists(creator_address);
        assert!(token::balance_of(creator_address, token_id) == 0, 0);

        cancel_game(creator);

        assert!(token::balance_of(creator_address, token_id) == 1, 0);
        assert_nftango_store_is_not_active(creator_address);
    }

    #[test(aptos_framework = @0x1, nft_owner = @0xCAFE, creator = @0x12)]
    #[expected_failure(abort_code = 3, location = overmind::nftango)]
    fun test_cancel_game_failure_is_not_active(
        aptos_framework: &signer,
        nft_owner: &signer,
        creator: &signer
    ) {
        let aptos_framework_address = signer::address_of(aptos_framework);
        let nft_owner_address = signer::address_of(nft_owner);
        let creator_address = signer::address_of(creator);

        account::create_account_for_test(aptos_framework_address);
        account::create_account_for_test(nft_owner_address);
        account::create_account_for_test(creator_address);

        token::opt_in_direct_transfer(creator, true);

        let token_id = token::create_collection_and_token(
            nft_owner,
            10,
            1,
            10,
            vector<String>[],
            vector<vector<u8>>[],
            vector<String>[],
            vector<bool>[false, false, false],
            vector<bool>[false, false, false, false, true],
        );

        let (nft_creator, nft_collection_name, nft_token_name, nft_property_version) = token::get_token_id_fields(
            &token_id
        );

        token::transfer(nft_owner, token_id, creator_address, 1);

        initialize_game(
            creator,
            nft_creator,
            nft_collection_name,
            nft_token_name,
            nft_property_version,
            1
        );

        assert_nftango_store_exists(creator_address);
        assert!(token::balance_of(creator_address, token_id) == 0, 0);

        cancel_game(creator);
        cancel_game(creator);
    }

    #[test(aptos_framework = @0x1, nft_owner = @0xCAFE, creator = @0x12, opponent = @0x34)]
    #[expected_failure(abort_code = 4, location = overmind::nftango)]
    fun test_cancel_game_failure_already_has_an_opponent(
        aptos_framework: &signer,
        nft_owner: &signer,
        creator: &signer,
        opponent: &signer
    ) {
        let aptos_framework_address = signer::address_of(aptos_framework);
        let nft_owner_address = signer::address_of(nft_owner);
        let creator_address = signer::address_of(creator);
        let opponent_address = signer::address_of(opponent);

        account::create_account_for_test(aptos_framework_address);
        account::create_account_for_test(nft_owner_address);
        account::create_account_for_test(creator_address);
        account::create_account_for_test(opponent_address);

        token::opt_in_direct_transfer(creator, true);
        token::opt_in_direct_transfer(opponent, true);

        let token_id = token::create_collection_and_token(
            nft_owner,
            10,
            1,
            10,
            vector<String>[],
            vector<vector<u8>>[],
            vector<String>[],
            vector<bool>[false, false, false],
            vector<bool>[false, false, false, false, true],
        );

        let (nft_creator, nft_collection_name, nft_token_name, nft_property_version) = token::get_token_id_fields(
            &token_id
        );

        token::transfer(nft_owner, token_id, creator_address, 1);
        token::transfer(nft_owner, token_id, opponent_address, 1);

        initialize_game(
            creator,
            nft_creator,
            nft_collection_name,
            nft_token_name,
            nft_property_version,
            1
        );

        assert_nftango_store_exists(creator_address);
        assert!(token::balance_of(creator_address, token_id) == 0, 0);

        let nft_creators: vector<address> = vector::empty();
        let nft_collection_names: vector<String> = vector::empty();
        let nft_token_names: vector<String> = vector::empty();
        let nft_property_versions: vector<u64> = vector::empty();

        vector::push_back(&mut nft_creators, nft_creator);
        vector::push_back(&mut nft_collection_names, nft_collection_name);
        vector::push_back(&mut nft_token_names, nft_token_name);
        vector::push_back(&mut nft_property_versions, nft_property_version);

        join_game(
            opponent,
            creator_address,
            nft_creators,
            nft_collection_names,
            nft_token_names,
            nft_property_versions
        );
        cancel_game(creator);
    }

    #[test(aptos_framework = @0x1, nft_owner = @0xCAFE, creator = @0x12, opponent = @0x34)]
    fun test_join_game_success(
        aptos_framework: &signer,
        nft_owner: &signer,
        creator: &signer,
        opponent: &signer
    ) {
        let aptos_framework_address = signer::address_of(aptos_framework);
        let nft_owner_address = signer::address_of(nft_owner);
        let creator_address = signer::address_of(creator);
        let opponent_address = signer::address_of(opponent);

        account::create_account_for_test(aptos_framework_address);
        account::create_account_for_test(nft_owner_address);
        account::create_account_for_test(creator_address);
        account::create_account_for_test(opponent_address);

        token::opt_in_direct_transfer(creator, true);
        token::opt_in_direct_transfer(opponent, true);

        let token_id = token::create_collection_and_token(
            nft_owner,
            10,
            1,
            10,
            vector<String>[],
            vector<vector<u8>>[],
            vector<String>[],
            vector<bool>[false, false, false],
            vector<bool>[false, false, false, false, true],
        );

        let (nft_creator, nft_collection_name, nft_token_name, nft_property_version) = token::get_token_id_fields(
            &token_id
        );

        token::transfer(nft_owner, token_id, creator_address, 1);
        token::transfer(nft_owner, token_id, opponent_address, 1);

        initialize_game(
            creator,
            nft_creator,
            nft_collection_name,
            nft_token_name,
            nft_property_version,
            1
        );

        assert_nftango_store_exists(creator_address);
        assert!(token::balance_of(creator_address, token_id) == 0, 0);

        let nft_creators: vector<address> = vector::empty();
        let nft_collection_names: vector<String> = vector::empty();
        let nft_token_names: vector<String> = vector::empty();
        let nft_property_versions: vector<u64> = vector::empty();

        vector::push_back(&mut nft_creators, nft_creator);
        vector::push_back(&mut nft_collection_names, nft_collection_name);
        vector::push_back(&mut nft_token_names, nft_token_name);
        vector::push_back(&mut nft_property_versions, nft_property_version);

        join_game(
            opponent,
            creator_address,
            nft_creators,
            nft_collection_names,
            nft_token_names,
            nft_property_versions
        );
        assert!(token::balance_of(opponent_address, token_id) == 0, 0);
        assert_nftango_store_has_an_opponent(creator_address);
    }

    #[test(aptos_framework = @0x1, nft_owner = @0xCAFE, creator = @0x12, opponent = @0x34)]
    #[expected_failure(abort_code = 4, location = overmind::nftango)]
    fun test_join_game_failure_has_an_opponent(
        aptos_framework: &signer,
        nft_owner: &signer,
        creator: &signer,
        opponent: &signer
    ) {
        let aptos_framework_address = signer::address_of(aptos_framework);
        let nft_owner_address = signer::address_of(nft_owner);
        let creator_address = signer::address_of(creator);
        let opponent_address = signer::address_of(opponent);

        account::create_account_for_test(aptos_framework_address);
        account::create_account_for_test(nft_owner_address);
        account::create_account_for_test(creator_address);
        account::create_account_for_test(opponent_address);

        token::opt_in_direct_transfer(creator, true);
        token::opt_in_direct_transfer(opponent, true);

        let token_id = token::create_collection_and_token(
            nft_owner,
            10,
            1,
            10,
            vector<String>[],
            vector<vector<u8>>[],
            vector<String>[],
            vector<bool>[false, false, false],
            vector<bool>[false, false, false, false, true],
        );

        let (nft_creator, nft_collection_name, nft_token_name, nft_property_version) = token::get_token_id_fields(
            &token_id
        );

        token::transfer(nft_owner, token_id, creator_address, 1);
        token::transfer(nft_owner, token_id, opponent_address, 1);

        initialize_game(
            creator,
            nft_creator,
            nft_collection_name,
            nft_token_name,
            nft_property_version,
            1
        );

        assert_nftango_store_exists(creator_address);
        assert!(token::balance_of(creator_address, token_id) == 0, 0);

        let nft_creators: vector<address> = vector::empty();
        let nft_collection_names: vector<String> = vector::empty();
        let nft_token_names: vector<String> = vector::empty();
        let nft_property_versions: vector<u64> = vector::empty();

        vector::push_back(&mut nft_creators, nft_creator);
        vector::push_back(&mut nft_collection_names, nft_collection_name);
        vector::push_back(&mut nft_token_names, nft_token_name);
        vector::push_back(&mut nft_property_versions, nft_property_version);

        join_game(
            opponent,
            creator_address,
            nft_creators,
            nft_collection_names,
            nft_token_names,
            nft_property_versions
        );
        join_game(
            opponent,
            creator_address,
            nft_creators,
            nft_collection_names,
            nft_token_names,
            nft_property_versions
        );
    }

    #[test(aptos_framework = @0x1, nft_owner = @0xCAFE, creator = @0x12, opponent = @0x34)]
    #[expected_failure(abort_code = 6, location = overmind::nftango)]
    fun test_join_game_failure_join_amount_requirement_is_not_met(
        aptos_framework: &signer,
        nft_owner: &signer,
        creator: &signer,
        opponent: &signer
    ) {
        let aptos_framework_address = signer::address_of(aptos_framework);
        let nft_owner_address = signer::address_of(nft_owner);
        let creator_address = signer::address_of(creator);
        let opponent_address = signer::address_of(opponent);

        account::create_account_for_test(aptos_framework_address);
        account::create_account_for_test(nft_owner_address);
        account::create_account_for_test(creator_address);
        account::create_account_for_test(opponent_address);

        token::opt_in_direct_transfer(creator, true);
        token::opt_in_direct_transfer(opponent, true);

        let token_id = token::create_collection_and_token(
            nft_owner,
            10,
            1,
            10,
            vector<String>[],
            vector<vector<u8>>[],
            vector<String>[],
            vector<bool>[false, false, false],
            vector<bool>[false, false, false, false, true],
        );

        let (nft_creator, nft_collection_name, nft_token_name, nft_property_version) = token::get_token_id_fields(
            &token_id
        );

        token::transfer(nft_owner, token_id, creator_address, 1);
        token::transfer(nft_owner, token_id, opponent_address, 1);

        initialize_game(
            creator,
            nft_creator,
            nft_collection_name,
            nft_token_name,
            nft_property_version,
            3
        );

        assert_nftango_store_exists(creator_address);
        assert!(token::balance_of(creator_address, token_id) == 0, 0);

        let nft_creators: vector<address> = vector::empty();
        let nft_collection_names: vector<String> = vector::empty();
        let nft_token_names: vector<String> = vector::empty();
        let nft_property_versions: vector<u64> = vector::empty();

        vector::push_back(&mut nft_creators, nft_creator);
        vector::push_back(&mut nft_collection_names, nft_collection_name);
        vector::push_back(&mut nft_token_names, nft_token_name);
        vector::push_back(&mut nft_property_versions, nft_property_version);

        join_game(
            opponent,
            creator_address,
            nft_creators,
            nft_collection_names,
            nft_token_names,
            nft_property_versions
        );
    }

    #[test(aptos_framework = @0x1, nft_owner = @0xCAFE, creator = @0x12, opponent = @0x34)]
    fun test_play_game_success(
        aptos_framework: &signer,
        nft_owner: &signer,
        creator: &signer,
        opponent: &signer
    ) {
        let aptos_framework_address = signer::address_of(aptos_framework);
        let nft_owner_address = signer::address_of(nft_owner);
        let creator_address = signer::address_of(creator);
        let opponent_address = signer::address_of(opponent);

        account::create_account_for_test(aptos_framework_address);
        account::create_account_for_test(nft_owner_address);
        account::create_account_for_test(creator_address);
        account::create_account_for_test(opponent_address);

        token::opt_in_direct_transfer(creator, true);
        token::opt_in_direct_transfer(opponent, true);

        let token_id = token::create_collection_and_token(
            nft_owner,
            10,
            1,
            10,
            vector<String>[],
            vector<vector<u8>>[],
            vector<String>[],
            vector<bool>[false, false, false],
            vector<bool>[false, false, false, false, true],
        );

        let (nft_creator, nft_collection_name, nft_token_name, nft_property_version) = token::get_token_id_fields(
            &token_id
        );

        token::transfer(nft_owner, token_id, creator_address, 1);
        token::transfer(nft_owner, token_id, opponent_address, 1);

        initialize_game(
            creator,
            nft_creator,
            nft_collection_name,
            nft_token_name,
            nft_property_version,
            1
        );

        assert_nftango_store_exists(creator_address);
        assert!(token::balance_of(creator_address, token_id) == 0, 0);

        let nft_creators: vector<address> = vector::empty();
        let nft_collection_names: vector<String> = vector::empty();
        let nft_token_names: vector<String> = vector::empty();
        let nft_property_versions: vector<u64> = vector::empty();

        vector::push_back(&mut nft_creators, nft_creator);
        vector::push_back(&mut nft_collection_names, nft_collection_name);
        vector::push_back(&mut nft_token_names, nft_token_name);
        vector::push_back(&mut nft_property_versions, nft_property_version);

        join_game(
            opponent,
            creator_address,
            nft_creators,
            nft_collection_names,
            nft_token_names,
            nft_property_versions
        );
        assert!(token::balance_of(opponent_address, token_id) == 0, 0);
        assert_nftango_store_has_an_opponent(creator_address);

        play_game(creator, true);
        assert_nftango_store_is_not_active(creator_address);
    }

    #[test(aptos_framework = @0x1, nft_owner = @0xCAFE, creator = @0x12, opponent = @0x34)]
    fun test_claim_success(
        aptos_framework: &signer,
        nft_owner: &signer,
        creator: &signer,
        opponent: &signer
    ) {
        let aptos_framework_address = signer::address_of(aptos_framework);
        let nft_owner_address = signer::address_of(nft_owner);
        let creator_address = signer::address_of(creator);
        let opponent_address = signer::address_of(opponent);

        account::create_account_for_test(aptos_framework_address);
        account::create_account_for_test(nft_owner_address);
        account::create_account_for_test(creator_address);
        account::create_account_for_test(opponent_address);

        token::opt_in_direct_transfer(creator, true);
        token::opt_in_direct_transfer(opponent, true);

        let token_id = token::create_collection_and_token(
            nft_owner,
            10,
            1,
            10,
            vector<String>[],
            vector<vector<u8>>[],
            vector<String>[],
            vector<bool>[false, false, false],
            vector<bool>[false, false, false, false, true],
        );

        let (nft_creator, nft_collection_name, nft_token_name, nft_property_version) = token::get_token_id_fields(
            &token_id
        );

        token::transfer(nft_owner, token_id, creator_address, 1);
        token::transfer(nft_owner, token_id, opponent_address, 1);

        initialize_game(
            creator,
            nft_creator,
            nft_collection_name,
            nft_token_name,
            nft_property_version,
            1
        );

        assert_nftango_store_exists(creator_address);
        assert!(token::balance_of(creator_address, token_id) == 0, 0);

        let nft_creators: vector<address> = vector::empty();
        let nft_collection_names: vector<String> = vector::empty();
        let nft_token_names: vector<String> = vector::empty();
        let nft_property_versions: vector<u64> = vector::empty();

        vector::push_back(&mut nft_creators, nft_creator);
        vector::push_back(&mut nft_collection_names, nft_collection_name);
        vector::push_back(&mut nft_token_names, nft_token_name);
        vector::push_back(&mut nft_property_versions, nft_property_version);

        join_game(
            opponent,
            creator_address,
            nft_creators,
            nft_collection_names,
            nft_token_names,
            nft_property_versions
        );
        assert!(token::balance_of(opponent_address, token_id) == 0, 0);
        assert_nftango_store_has_an_opponent(creator_address);

        play_game(creator, true);
        assert_nftango_store_is_not_active(creator_address);

        claim(creator, creator_address);
        assert!(token::balance_of(creator_address, token_id) == 2, 0);
    }

    #[test(aptos_framework = @0x1, nft_owner = @0xCAFE, creator = @0x12, opponent = @0x34)]
    fun test_claim_opponent_success(
        aptos_framework: &signer,
        nft_owner: &signer,
        creator: &signer,
        opponent: &signer
    ) {
        let aptos_framework_address = signer::address_of(aptos_framework);
        let nft_owner_address = signer::address_of(nft_owner);
        let creator_address = signer::address_of(creator);
        let opponent_address = signer::address_of(opponent);

        account::create_account_for_test(aptos_framework_address);
        account::create_account_for_test(nft_owner_address);
        account::create_account_for_test(creator_address);
        account::create_account_for_test(opponent_address);

        token::opt_in_direct_transfer(creator, true);
        token::opt_in_direct_transfer(opponent, true);

        let token_id = token::create_collection_and_token(
            nft_owner,
            10,
            1,
            10,
            vector<String>[],
            vector<vector<u8>>[],
            vector<String>[],
            vector<bool>[false, false, false],
            vector<bool>[false, false, false, false, true],
        );

        let (nft_creator, nft_collection_name, nft_token_name, nft_property_version) = token::get_token_id_fields(
            &token_id
        );

        token::transfer(nft_owner, token_id, creator_address, 1);
        token::transfer(nft_owner, token_id, opponent_address, 1);

        initialize_game(
            creator,
            nft_creator,
            nft_collection_name,
            nft_token_name,
            nft_property_version,
            1
        );

        assert_nftango_store_exists(creator_address);
        assert!(token::balance_of(creator_address, token_id) == 0, 0);

        let nft_creators: vector<address> = vector::empty();
        let nft_collection_names: vector<String> = vector::empty();
        let nft_token_names: vector<String> = vector::empty();
        let nft_property_versions: vector<u64> = vector::empty();

        vector::push_back(&mut nft_creators, nft_creator);
        vector::push_back(&mut nft_collection_names, nft_collection_name);
        vector::push_back(&mut nft_token_names, nft_token_name);
        vector::push_back(&mut nft_property_versions, nft_property_version);

        join_game(
            opponent,
            creator_address,
            nft_creators,
            nft_collection_names,
            nft_token_names,
            nft_property_versions
        );
        assert!(token::balance_of(opponent_address, token_id) == 0, 0);
        assert_nftango_store_has_an_opponent(creator_address);

        play_game(creator, false);
        assert_nftango_store_is_not_active(creator_address);

        claim(opponent, creator_address);
        assert!(token::balance_of(opponent_address, token_id) == 2, 0);
    }

    #[test(aptos_framework = @0x1, nft_owner = @0xCAFE, creator = @0x12, opponent = @0x34)]
    fun test_claim_success_multiple_join_amount_requirement(
        aptos_framework: &signer,
        nft_owner: &signer,
        creator: &signer,
        opponent: &signer
    ) {
        let aptos_framework_address = signer::address_of(aptos_framework);
        let nft_owner_address = signer::address_of(nft_owner);
        let creator_address = signer::address_of(creator);
        let opponent_address = signer::address_of(opponent);

        account::create_account_for_test(aptos_framework_address);
        account::create_account_for_test(nft_owner_address);
        account::create_account_for_test(creator_address);
        account::create_account_for_test(opponent_address);

        token::opt_in_direct_transfer(creator, true);
        token::opt_in_direct_transfer(opponent, true);

        let token_id = token::create_collection_and_token(
            nft_owner,
            10,
            1,
            10,
            vector<String>[],
            vector<vector<u8>>[],
            vector<String>[],
            vector<bool>[false, false, false],
            vector<bool>[false, false, false, false, true],
        );

        let (nft_creator, nft_collection_name, nft_token_name, nft_property_version) = token::get_token_id_fields(
            &token_id
        );

        token::transfer(nft_owner, token_id, creator_address, 1);
        token::transfer(nft_owner, token_id, opponent_address, 1);
        token::transfer(nft_owner, token_id, opponent_address, 1);
        token::transfer(nft_owner, token_id, opponent_address, 1);

        initialize_game(
            creator,
            nft_creator,
            nft_collection_name,
            nft_token_name,
            nft_property_version,
            3
        );

        assert_nftango_store_exists(creator_address);
        assert!(token::balance_of(creator_address, token_id) == 0, 0);

        let nft_creators: vector<address> = vector::empty();
        let nft_collection_names: vector<String> = vector::empty();
        let nft_token_names: vector<String> = vector::empty();
        let nft_property_versions: vector<u64> = vector::empty();

        vector::push_back(&mut nft_creators, nft_creator);
        vector::push_back(&mut nft_collection_names, nft_collection_name);
        vector::push_back(&mut nft_token_names, nft_token_name);
        vector::push_back(&mut nft_property_versions, nft_property_version);

        vector::push_back(&mut nft_creators, nft_creator);
        vector::push_back(&mut nft_collection_names, nft_collection_name);
        vector::push_back(&mut nft_token_names, nft_token_name);
        vector::push_back(&mut nft_property_versions, nft_property_version);

        vector::push_back(&mut nft_creators, nft_creator);
        vector::push_back(&mut nft_collection_names, nft_collection_name);
        vector::push_back(&mut nft_token_names, nft_token_name);
        vector::push_back(&mut nft_property_versions, nft_property_version);

        join_game(
            opponent,
            creator_address,
            nft_creators,
            nft_collection_names,
            nft_token_names,
            nft_property_versions
        );
        assert!(token::balance_of(opponent_address, token_id) == 0, 0);
        assert_nftango_store_has_an_opponent(creator_address);

        play_game(creator, true);
        assert_nftango_store_is_not_active(creator_address);

        claim(creator, creator_address);
        assert!(token::balance_of(creator_address, token_id) == 4, 0);
    }

    #[test(aptos_framework = @0x1, nft_owner = @0xCAFE, creator = @0x12, opponent = @0x34)]
    #[expected_failure(abort_code = 8, location = overmind::nftango)]
    fun test_claim_failure_has_claimed(
        aptos_framework: &signer,
        nft_owner: &signer,
        creator: &signer,
        opponent: &signer
    ) {
        let aptos_framework_address = signer::address_of(aptos_framework);
        let nft_owner_address = signer::address_of(nft_owner);
        let creator_address = signer::address_of(creator);
        let opponent_address = signer::address_of(opponent);

        account::create_account_for_test(aptos_framework_address);
        account::create_account_for_test(nft_owner_address);
        account::create_account_for_test(creator_address);
        account::create_account_for_test(opponent_address);

        token::opt_in_direct_transfer(creator, true);
        token::opt_in_direct_transfer(opponent, true);

        let token_id = token::create_collection_and_token(
            nft_owner,
            10,
            1,
            10,
            vector<String>[],
            vector<vector<u8>>[],
            vector<String>[],
            vector<bool>[false, false, false],
            vector<bool>[false, false, false, false, true],
        );

        let (nft_creator, nft_collection_name, nft_token_name, nft_property_version) = token::get_token_id_fields(
            &token_id
        );

        token::transfer(nft_owner, token_id, creator_address, 1);
        token::transfer(nft_owner, token_id, opponent_address, 1);

        initialize_game(
            creator,
            nft_creator,
            nft_collection_name,
            nft_token_name,
            nft_property_version,
            1
        );

        assert_nftango_store_exists(creator_address);
        assert!(token::balance_of(creator_address, token_id) == 0, 0);

        let nft_creators: vector<address> = vector::empty();
        let nft_collection_names: vector<String> = vector::empty();
        let nft_token_names: vector<String> = vector::empty();
        let nft_property_versions: vector<u64> = vector::empty();

        vector::push_back(&mut nft_creators, nft_creator);
        vector::push_back(&mut nft_collection_names, nft_collection_name);
        vector::push_back(&mut nft_token_names, nft_token_name);
        vector::push_back(&mut nft_property_versions, nft_property_version);

        join_game(
            opponent,
            creator_address,
            nft_creators,
            nft_collection_names,
            nft_token_names,
            nft_property_versions
        );
        assert!(token::balance_of(opponent_address, token_id) == 0, 0);
        assert_nftango_store_has_an_opponent(creator_address);

        play_game(creator, true);
        assert_nftango_store_is_not_active(creator_address);

        claim(creator, creator_address);
        claim(creator, creator_address);
    }

    #[test(aptos_framework = @0x1, nft_owner = @0xCAFE, creator = @0x12, opponent = @0x34, random = @0x56)]
    #[expected_failure(abort_code = 9, location = overmind::nftango)]
    fun test_claim_failure_is_not_player(
        aptos_framework: &signer,
        nft_owner: &signer,
        creator: &signer,
        opponent: &signer,
        random: &signer
    ) {
        let aptos_framework_address = signer::address_of(aptos_framework);
        let nft_owner_address = signer::address_of(nft_owner);
        let creator_address = signer::address_of(creator);
        let opponent_address = signer::address_of(opponent);
        let random_address = signer::address_of(random);

        account::create_account_for_test(aptos_framework_address);
        account::create_account_for_test(nft_owner_address);
        account::create_account_for_test(creator_address);
        account::create_account_for_test(opponent_address);
        account::create_account_for_test(random_address);

        token::opt_in_direct_transfer(creator, true);
        token::opt_in_direct_transfer(opponent, true);

        let token_id = token::create_collection_and_token(
            nft_owner,
            10,
            1,
            10,
            vector<String>[],
            vector<vector<u8>>[],
            vector<String>[],
            vector<bool>[false, false, false],
            vector<bool>[false, false, false, false, true],
        );

        let (nft_creator, nft_collection_name, nft_token_name, nft_property_version) = token::get_token_id_fields(
            &token_id
        );

        token::transfer(nft_owner, token_id, creator_address, 1);
        token::transfer(nft_owner, token_id, opponent_address, 1);

        initialize_game(
            creator,
            nft_creator,
            nft_collection_name,
            nft_token_name,
            nft_property_version,
            1
        );

        assert_nftango_store_exists(creator_address);
        assert!(token::balance_of(creator_address, token_id) == 0, 0);

        let nft_creators: vector<address> = vector::empty();
        let nft_collection_names: vector<String> = vector::empty();
        let nft_token_names: vector<String> = vector::empty();
        let nft_property_versions: vector<u64> = vector::empty();

        vector::push_back(&mut nft_creators, nft_creator);
        vector::push_back(&mut nft_collection_names, nft_collection_name);
        vector::push_back(&mut nft_token_names, nft_token_name);
        vector::push_back(&mut nft_property_versions, nft_property_version);

        join_game(
            opponent,
            creator_address,
            nft_creators,
            nft_collection_names,
            nft_token_names,
            nft_property_versions
        );
        assert!(token::balance_of(opponent_address, token_id) == 0, 0);
        assert_nftango_store_has_an_opponent(creator_address);

        play_game(creator, true);
        assert_nftango_store_is_not_active(creator_address);

        claim(random, creator_address);
    }
}