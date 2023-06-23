module overmind::nftango {
    use std::option::{Self,Option};
    use std::string::String;
    use std::vector;
    use std::signer;

    use aptos_framework::account;

    use aptos_token::token::{Self, TokenId};

    //
    // Errors
    //
    const ERROR_NFTANGO_STORE_EXISTS: u64 = 0;
    const ERROR_NFTANGO_STORE_DOES_NOT_EXIST: u64 = 1;
    const ERROR_NFTANGO_STORE_IS_ACTIVE: u64 = 2;
    const ERROR_NFTANGO_STORE_IS_NOT_ACTIVE: u64 = 3;
    const ERROR_NFTANGO_STORE_HAS_AN_OPPONENT: u64 = 4;
    const ERROR_NFTANGO_STORE_DOES_NOT_HAVE_AN_OPPONENT: u64 = 5;
    const ERROR_NFTANGO_STORE_JOIN_AMOUNT_REQUIREMENT_NOT_MET: u64 = 6;
    const ERROR_NFTANGO_STORE_DOES_NOT_HAVE_DID_CREATOR_WIN: u64 = 7;
    const ERROR_NFTANGO_STORE_HAS_CLAIMED: u64 = 8;
    const ERROR_NFTANGO_STORE_IS_NOT_PLAYER: u64 = 9;
    const ERROR_VECTOR_LENGTHS_NOT_EQUAL: u64 = 10;

    //
    // Data structures
    //
    struct NFTangoStore has key {
        creator_token_id: TokenId,
        // The number of NFTs (one more more) from the same collection that the opponent needs to bet to enter the game
        join_amount_requirement: u64,
        opponent_address: Option<address>,
        opponent_token_ids: vector<TokenId>,
        active: bool,
        has_claimed: bool,
        did_creator_win: Option<bool>,
        signer_capability: account::SignerCapability
    }

    //
    // Assert functions
    //
    public fun assert_nftango_store_exists(
        account_address: address,
    ) {
        // TODO: assert that `NFTangoStore` exists
        assert!(exists<NFTangoStore>(account_address), ERROR_NFTANGO_STORE_DOES_NOT_EXIST);
    }

    public fun assert_nftango_store_does_not_exist(
        account_address: address,
    ) {
        // TODO: assert that `NFTangoStore` does not exist
        assert!(!exists<NFTangoStore>(account_address), ERROR_NFTANGO_STORE_EXISTS);
    }

    public fun assert_nftango_store_is_active(
        account_address: address,
    ) acquires NFTangoStore {
        // TODO: assert that `NFTangoStore.active` is active
        let store = borrow_global<NFTangoStore>(account_address);
        assert!(store.active, ERROR_NFTANGO_STORE_IS_NOT_ACTIVE);
    }

    public fun assert_nftango_store_is_not_active(
        account_address: address,
    ) acquires NFTangoStore {
        // TODO: assert that `NFTangoStore.active` is not active
        let store = borrow_global<NFTangoStore>(account_address);
        assert!(!store.active, ERROR_NFTANGO_STORE_IS_ACTIVE);
    }

    public fun assert_nftango_store_has_an_opponent(
        account_address: address,
    ) acquires NFTangoStore {
        // TODO: assert that `NFTangoStore.opponent_address` is set
        let store = borrow_global<NFTangoStore>(account_address);
        assert!(option::is_some(&store.opponent_address), ERROR_NFTANGO_STORE_DOES_NOT_HAVE_AN_OPPONENT);
    }

    public fun assert_nftango_store_does_not_have_an_opponent(
        account_address: address,
    ) acquires NFTangoStore {
        // TODO: assert that `NFTangoStore.opponent_address` is not set
        let store = borrow_global<NFTangoStore>(account_address);
        assert!(!option::is_some(&store.opponent_address), ERROR_NFTANGO_STORE_HAS_AN_OPPONENT);
    }

    public fun assert_nftango_store_join_amount_requirement_is_met(
        game_address: address,
        token_ids: vector<TokenId>,
    ) acquires NFTangoStore {
        // TODO: assert that `NFTangoStore.join_amount_requirement` is met
        let store = borrow_global<NFTangoStore>(game_address);
        assert!(store.join_amount_requirement == vector::length<TokenId>(&token_ids), ERROR_NFTANGO_STORE_JOIN_AMOUNT_REQUIREMENT_NOT_MET);
    }

    public fun assert_nftango_store_has_did_creator_win(
        game_address: address,
    ) acquires NFTangoStore {
        // TODO: assert that `NFTangoStore.did_creator_win` is set
        let store = borrow_global<NFTangoStore>(game_address);
        assert!(option::is_some(&store.did_creator_win), ERROR_NFTANGO_STORE_DOES_NOT_HAVE_DID_CREATOR_WIN);
    }

    public fun assert_nftango_store_has_not_claimed(
        game_address: address,
    ) acquires NFTangoStore {
        // TODO: assert that `NFTangoStore.has_claimed` is false
        let store = borrow_global<NFTangoStore>(game_address);
        assert!(!store.has_claimed, ERROR_NFTANGO_STORE_HAS_CLAIMED);
    }

    public fun assert_nftango_store_is_player(account_address: address, game_address: address) acquires NFTangoStore {
        // TODO: assert that `account_address` is either the equal to `game_address` or `NFTangoStore.opponent_address`
        let store = borrow_global<NFTangoStore>(game_address);
        assert!(account_address == game_address || account_address == *option::borrow(&store.opponent_address), ERROR_NFTANGO_STORE_IS_NOT_PLAYER);
    }

    public fun assert_vector_lengths_are_equal(creator: vector<address>,
                                               collection_name: vector<String>,
                                               token_name: vector<String>,
                                               property_version: vector<u64>) {
        // TODO: assert all vector lengths are equal
        let creator_len = vector::length(&creator);
        let collection_name_len = vector::length(&collection_name);
        let token_name_len = vector::length(&token_name);
        let property_version_len = vector::length(&property_version);

        assert!(creator_len == collection_name_len, ERROR_VECTOR_LENGTHS_NOT_EQUAL);
        assert!(creator_len == property_version_len, ERROR_VECTOR_LENGTHS_NOT_EQUAL);
        assert!(creator_len == token_name_len, ERROR_VECTOR_LENGTHS_NOT_EQUAL);
    }

    fun get_resource_account_cap(game_address : address) : signer acquires NFTangoStore{
        let store = borrow_global<NFTangoStore>(game_address);
        account::create_signer_with_capability(&store.signer_capability)
    }

    //
    // Entry functions
    //
    public entry fun initialize_game(
        account: &signer,
        creator: address,
        collection_name: String,
        token_name: String,
        property_version: u64,
        join_amount_requirement: u64
    ) {
        // TODO: run assert_nftango_store_does_not_exist
        assert_nftango_store_does_not_exist(signer::address_of(account));
        // TODO: create resource account
        let (resource_signer, signer_cap) = account::create_resource_account(account, x"01");
        // TODO: token::create_token_id_raw
        let token_id = token::create_token_id_raw(creator, collection_name, token_name, property_version);
        // TODO: opt in to direct transfer for resource account
        token::opt_in_direct_transfer(&resource_signer, true);
        // TODO: transfer NFT to resource account
        token::transfer(account, token_id, signer::address_of(&resource_signer), 1);
        // TODO: move_to resource `NFTangoStore` to account signer
        move_to<NFTangoStore>(account, NFTangoStore{
            creator_token_id: token_id,
            join_amount_requirement: join_amount_requirement,
            opponent_address: option::none<address>(),
            opponent_token_ids: vector::empty<TokenId>(),
            active: true,
            has_claimed: false,
            did_creator_win: option::none<bool>(),
            signer_capability: signer_cap
        })
    }

    public entry fun cancel_game(
        account: &signer,
    ) acquires NFTangoStore {
        // TODO: run assert_nftango_store_exists
        assert_nftango_store_exists(signer::address_of(account));
        // TODO: run assert_nftango_store_is_active
        assert_nftango_store_is_active(signer::address_of(account));
        // TODO: run assert_nftango_store_does_not_have_an_opponent
        assert_nftango_store_does_not_have_an_opponent(signer::address_of(account));
        // TODO: opt in to direct transfer for account
        token::opt_in_direct_transfer(account, true);
        // TODO: transfer NFT to account address
        let resource_signer = get_resource_account_cap(signer::address_of(account));
        let store = borrow_global_mut<NFTangoStore>(signer::address_of(account));
        token::transfer(&resource_signer, store.creator_token_id, signer::address_of(account), 1);
        // TODO: set `NFTangoStore.active` to false
        store.active = false;
    }

    public fun join_game(
        account: &signer,
        game_address: address,
        creators: vector<address>,
        collection_names: vector<String>,
        token_names: vector<String>,
        property_versions: vector<u64>,
    ) acquires NFTangoStore {
        // TODO: run assert_vector_lengths_are_equal
        assert_vector_lengths_are_equal(creators, collection_names, token_names, property_versions);
        // TODO: loop through and create token_ids vector<TokenId>
        let token_ids = vector::empty<TokenId>();
        let len = vector::length<address>(&creators);
        let i = 0;
        while (i < len) {
            let creator = vector::borrow(&creators, i); 
            let collection_name = vector::borrow(&collection_names, i); 
            let token_name = vector::borrow(&token_names, i); 
            let property_version = vector::borrow(&property_versions, i); 
            let token_id = token::create_token_id_raw(*creator, *collection_name, *token_name, *property_version);
            vector::push_back<TokenId>(&mut token_ids, token_id);
            i = i + 1;
        };
        // TODO: run assert_nftango_store_exists
        assert_nftango_store_exists(game_address);
        // TODO: run assert_nftango_store_is_active
        assert_nftango_store_is_active(game_address);
        // TODO: run assert_nftango_store_does_not_have_an_opponent
        assert_nftango_store_does_not_have_an_opponent(game_address);
        // TODO: run assert_nftango_store_join_amount_requirement_is_met
        assert_nftango_store_join_amount_requirement_is_met(game_address, token_ids);
        // TODO: loop through token_ids and transfer each NFT to the resource account
        let resource_signer = get_resource_account_cap(game_address);
        i = 0;
        len = vector::length<TokenId>(&token_ids);
        let store = borrow_global_mut<NFTangoStore>(game_address);
        while (i < len) {
            let token_id = vector::borrow(&token_ids, i);
            token::transfer(account, *token_id, signer::address_of(&resource_signer), 1);
            // TODO: set `NFTangoStore.opponent_token_ids` to token_ids
            vector::push_back<TokenId>(&mut store.opponent_token_ids, *token_id);
            i = i + 1;
        };
        // TODO: set `NFTangoStore.opponent_address` to account_address
        store.opponent_address = option::some(signer::address_of(account));
    }

    public entry fun play_game(account: &signer, did_creator_win: bool) acquires NFTangoStore {
        // TODO: run assert_nftango_store_exists
        assert_nftango_store_exists(signer::address_of(account));
        // TODO: run assert_nftango_store_is_active
        assert_nftango_store_is_active(signer::address_of(account));
        // TODO: run assert_nftango_store_has_an_opponent
        assert_nftango_store_has_an_opponent(signer::address_of(account));

        // TODO: set `NFTangoStore.did_creator_win` to did_creator_win
        let store = borrow_global_mut<NFTangoStore>(signer::address_of(account));
        store.did_creator_win = option::some(did_creator_win);        
        // TODO: set `NFTangoStore.active` to false
        store.active = false;
    }

    public entry fun claim(account: &signer, game_address: address) acquires NFTangoStore {
        // TODO: run assert_nftango_store_exists
        assert_nftango_store_exists(game_address);
        // TODO: run assert_nftango_store_is_not_active
        assert_nftango_store_is_not_active(game_address);
        // TODO: run assert_nftango_store_has_not_claimed
        assert_nftango_store_has_not_claimed(game_address);
        // TODO: run assert_nftango_store_is_player
        assert_nftango_store_is_player(signer::address_of(account), game_address);

        // TODO: if the player won, send them all the NFTs
        let resource_signer = get_resource_account_cap(game_address);
        let store = borrow_global_mut<NFTangoStore>(game_address);
        store.has_claimed = true;
        let len = vector::length<TokenId>(&store.opponent_token_ids);
        // TODO: set `NFTangoStore.has_claimed` to true
        let winner = game_address;
        if (!*option::borrow(&store.did_creator_win)) {
            winner = *option::borrow(&store.opponent_address);
        };
        let i = 0;        
        while (i < len) {
            let token_id = vector::borrow(&store.opponent_token_ids, i);
            token::transfer(&resource_signer, *token_id, winner, 1);
            i = i + 1;
        };
        token::transfer(&resource_signer, store.creator_token_id, winner, 1);
    }
}
