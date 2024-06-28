    function mintNonFungible(
        uint256 _type,
        address[] calldata _to
    ) external {
        string memory _name = TokenDataFacet(address(this)).getTokenName(_type);
        if(keccak256(bytes(_name)) == keccak256(bytes('governor'))){
            uint256 balance = TokenDataFacet(address(this)).balanceOfName(msg.sender, 'governor');
            require(balance > 0, 'must hold Governor NFT to mint');
        }
        LibTokens.mintNonFungible(_type, _to);
    }