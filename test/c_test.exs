defmodule Exbtc.CTest do
	use ExUnit.Case
  alias Exbtc.C

  @prime_20 36413321723440003717
  @prime_70 4669523849932130508876392554713407521319117239637943224980015676156491

  test "inv function should work" do
    assert C.inv(2000, 213737) == 34946
  end

  test "inv function should work for big number" do
    a = 13435346457568578678674573497534908590348590
    assert C.inv(a, C.n) == 76817129878242043889804541567157985025477981670957762141827241685876907406246
  end

  test "jacobian_double should work" do
    a = {13434321, 982451653}
    assert C.jacobian_double(C.to_jacobian(a)) == {
      293056723988571195398282018817,
      115792089237316195423570985008687749207851136822633023217124110674511503608112,
      1964903306}
  end

  #
  # private key encoding decoding
  #
  @private_key_hex            "3aba4162c7251c891207b747840551a71939b0de081f85c4e44cf7c13e41daa6"
  @private_key_hex_compressed @private_key_hex <> "01"
  @private_key 26563230048437957592232553826663696440606756685920117476832299673293013768870
  @private_key_wif            "5JG9hT3beGTJuUAmCQEmNaxAuMacCTfXuw1R3FCXig23RQHMr4K"
  @private_key_wif_compressed "KyBsPXxTuVD82av65KZkrGrWi5qLMah5SdNq6uftawDbgKa2wv6S"

  @private_key_2_wif  "5J3mBbAH58CpQ3Y5RNJpUKPE62SQ5tfcvU2JpbnkeyhfsYB1Jcn"

  test "decode_privkey from hex" do
    assert C.decode_privkey(@private_key_hex, "hex") == \
      @private_key
  end

  test "encode_privkey to wif" do
    assert C.encode_privkey(@private_key, "wif") == @private_key_wif
  end

  test "encode_privkey hex_compressed" do
    assert C.encode_privkey(@private_key, "hex_compressed") == @private_key_hex_compressed
  end

  test "encode_privkey for wif_compressed" do
    assert C.encode_privkey(@private_key, "wif_compressed") == @private_key_wif_compressed
  end

  test "decode_privkey from wif" do
    assert C.decode_privkey(@private_key_wif, "wif") == @private_key
  end

  test "decode_privkey from wif_compressed" do
    assert C.decode_privkey(@private_key_wif_compressed, "wif_compressed") == @private_key
  end

  test "add_privkey works for 2 different priv keys" do
    assert C.add_privkeys(@private_key_wif, @private_key_2_wif) == "5JVdJMkndw693WKZaa6gkrbGmnC65DU57axwdfwY8ms58H7JDB2"
  end

  test "multiply_privkey works for 2 different priv keys" do
    assert C.multiply_privkeys(@private_key_wif, @private_key_2_wif) == "5JQcPxKuuMjHkWdtJbs1a3JQXAop9egPr5ay8hcccCqRXHFwBa9"  
  end

  test "create public key from private key" do
    assert C.privkey_to_pubkey(@private_key_wif) == "045c0de3b9c8ab18dd04e3511243ec2952002dbfadc864b9628910169d9b9b00ec243bcefdd4347074d44bd7356d6a53c495737dd96295e2a9374bf5f02ebfc176"
  end

  # 
  # address
  # 

  @address "1thMirt546nngXqyPEz532S8fLwbozud8"

  test "address generated by public key (hex)" do
    pubkey = "045c0de3b9c8ab18dd04e3511243ec2952002dbfadc864b9628910169d9b9b00ec243bcefdd4347074d44bd7356d6a53c495737dd96295e2a9374bf5f02ebfc176"
    assert C.pubkey_to_address(pubkey) == @address
  end

  test "address generated by public key (hex compressed)" do
    pubkey = "025c0de3b9c8ab18dd04e3511243ec2952002dbfadc864b9628910169d9b9b00ec"
    assert C.pubkey_to_address(pubkey) == @address
  end

  #
  # public key encoding decoding
  #

  @pub_key_tup {55066263022277343669578718895168534326250603453777594175500187360389116729240, \
           32670510020758816978083085130507043184471273380659243275938904335757337482424}

  #
  # bin codec
  #
  test "encode_pubkey should work for bin encoding" do
    assert C.encode_pubkey(@pub_key_tup, "bin") == \
      [4, 121, 190, 102, 126, 249, 220, 187, 172, 85, 160, 98, 149, 206, 135, 11, 7, 2, 155, 252, 219, 45, 206, 40, 217, 89, 242, 129, 91, 22, 248, 23, 152, 72, 58, 218, 119, 38, 163, 196, 101, 93, 164, 251, 252, 14, 17, 8, 168, 253, 23, 180, 72, 166, 133, 84, 25, 156, 71, 208, 143, 251, 16, 212, 184]
  end

  test "decode_pubkey should work for bin encoding" do
    assert C.decode_pubkey(
      [4, 121, 190, 102, 126, 249, 220, 187, 172, 85, 160, 98, 149, 206, 135, 11, 7, 2, 155, 252, 219, 45, 206, 40, 217, 89, 242, 129, 91, 22, 248, 23, 152, 72, 58, 218, 119, 38, 163, 196, 101, 93, 164, 251, 252, 14, 17, 8, 168, 253, 23, 180, 72, 166, 133, 84, 25, 156, 71, 208, 143, 251, 16, 212, 184],
      "bin") == @pub_key_tup
  end

  #
  # bin_compressed codec
  #
  test "encode_pubkey should work for bin_compressed encoding" do
    assert C.encode_pubkey(@pub_key_tup, "bin_compressed") == \
      [2, 121, 190, 102, 126, 249, 220, 187, 172, 85, 160, 98, 149, 206, 135, 11, 7, 2, 155, 252, 219, 45, 206, 40, 217, 89, 242, 129, 91, 22, 248, 23, 152]
  end

  test "decode_pubkey should work for bin_compressed" do
    assert C.decode_pubkey(
      [2, 121, 190, 102, 126, 249, 220, 187, 172, 85, 160, 98, 149, 206, 135, 11, 7, 2, 155, 252, 219, 45, 206, 40, 217, 89, 242, 129, 91, 22, 248, 23, 152],
      "bin_compressed" ) == @pub_key_tup
  end

  #
  # hex codec
  #
  test "encode_pubkey should work for hex encoding" do
    assert C.encode_pubkey(@pub_key_tup, "hex") == \
      "0479be667ef9dcbbac55a06295ce870b07029bfcdb2dce28d959f2815b16f81798483ada7726a3c4655da4fbfc0e1108a8fd17b448a68554199c47d08ffb10d4b8"
  end

  test "decode_pubkey should work for hex encoding" do
    assert C.decode_pubkey(
      "0479be667ef9dcbbac55a06295ce870b07029bfcdb2dce28d959f2815b16f81798483ada7726a3c4655da4fbfc0e1108a8fd17b448a68554199c47d08ffb10d4b8",
      "hex") == \
      @pub_key_tup    
  end

  #
  # hex_compressed codec
  #
  test "encode_pubkey should work for hex_compressed encoding" do
    assert C.encode_pubkey(@pub_key_tup, "hex_compressed") == \
      "0279be667ef9dcbbac55a06295ce870b07029bfcdb2dce28d959f2815b16f81798"
  end

  test "decode_pubkey should work for hex_compressed" do
    assert C.decode_pubkey(
      "0279be667ef9dcbbac55a06295ce870b07029bfcdb2dce28d959f2815b16f81798", 
      "hex_compressed" 
      ) == @pub_key_tup
  end

  #
  # bin_electrum codec
  #
  test "encode_pubkey should work for bin_electrum encoding" do
    assert C.encode_pubkey(@pub_key_tup, "bin_electrum") == \
      [121, 190, 102, 126, 249, 220, 187, 172, 85, 160, 98, 149, 206, 135, 11, 7, 2, 155, 252, 219, 45, 206, 40, 217, 89, 242, 129, 91, 22, 248, 23, 152, 72, 58, 218, 119, 38, 163, 196, 101, 93, 164, 251, 252, 14, 17, 8, 168, 253, 23, 180, 72, 166, 133, 84, 25, 156, 71, 208, 143, 251, 16, 212, 184]
  end

  test "decode_pubkey should work for bin_electrum" do
    assert C.decode_pubkey(
      [121, 190, 102, 126, 249, 220, 187, 172, 85, 160, 98, 149, 206, 135, 11, 7, 2, 155, 252, 219, 45, 206, 40, 217, 89, 242, 129, 91, 22, 248, 23, 152, 72, 58, 218, 119, 38, 163, 196, 101, 93, 164, 251, 252, 14, 17, 8, 168, 253, 23, 180, 72, 166, 133, 84, 25, 156, 71, 208, 143, 251, 16, 212, 184],
      "bin_electrum"
      ) == @pub_key_tup
  end

  #
  # hex_electrum codec
  #
  test "encode_pubkey should work for hex_electrum encoding" do
    assert C.encode_pubkey(@pub_key_tup, "hex_electrum") == \
      "79be667ef9dcbbac55a06295ce870b07029bfcdb2dce28d959f2815b16f81798483ada7726a3c4655da4fbfc0e1108a8fd17b448a68554199c47d08ffb10d4b8"
  end

  test "decode_pubkey should work for hex_electrum" do
    assert C.decode_pubkey(
      "79be667ef9dcbbac55a06295ce870b07029bfcdb2dce28d959f2815b16f81798483ada7726a3c4655da4fbfc0e1108a8fd17b448a68554199c47d08ffb10d4b8",
      "hex_electrum"
      ) == @pub_key_tup
  end

  test "encode_pubkey should raise error" do
    assert_raise RuntimeError, ~r/Invalid format/, fn -> C.encode_pubkey(@pub_key_tup, "foo") end
  end

  # 
  # others
  # 

  test "subtract 2 public keys" do
    assert C.subtract_pubkeys("025c0de3b9c8ab18dd04e3511243ec2952002dbfadc864b9628910169d9b9b00ec", 
      "0279be667ef9dcbbac55a06295ce870b07029bfcdb2dce28d959f2815b16f81798") == \
      "03581f559d90fbbe9c7d1bc4ff64bd4370401246ec7042c2ec090cf464551409c9"
  end

  test "substract 2 private key" do
    assert C.subtract_privkey("5JVdJMkndw693WKZaa6gkrbGmnC65DU57axwdfwY8ms58H7JDB2", @private_key_wif) 
      == @private_key_2_wif 
  end

  test "bin_sha256 works" do
     assert C.bin_sha256([30, 153, 66, 58, 78, 210, 118, 8, 161, 90, 38, 22, 162, 176, 233, 229, 44, 237, 51, 10, 197, 48, 237, 204, 50, 200, 255, 198, 165, 38, 174, 221, 1]) 
       == [15, 242, 75, 80, 107, 229, 49, 241, 63, 101, 96, 146, 97, 132, 114, 148, 221, 146, 2, 34, 143, 136, 61, 120, 5, 180, 33, 106, 42, 17, 244, 27]     
  end

  test "multiply pubkey with privkey" do
    assert C.multiply("025c0de3b9c8ab18dd04e3511243ec2952002dbfadc864b9628910169d9b9b00ec", @private_key_wif) 
      == "02965afb5335cdaf9fcf4c5b67e976b87413e8a4a022d7f163928d8af7d652c9a9"
  end

  test "compress hex pubkey" do
    assert C.compress("0479be667ef9dcbbac55a06295ce870b07029bfcdb2dce28d959f2815b16f81798483ada7726a3c4655da4fbfc0e1108a8fd17b448a68554199c47d08ffb10d4b8") 
      == "0279be667ef9dcbbac55a06295ce870b07029bfcdb2dce28d959f2815b16f81798"
  end

  test "decompress hex_compress pubkey" do
    assert C.decompress("0279be667ef9dcbbac55a06295ce870b07029bfcdb2dce28d959f2815b16f81798") 
      == "0479be667ef9dcbbac55a06295ce870b07029bfcdb2dce28d959f2815b16f81798483ada7726a3c4655da4fbfc0e1108a8fd17b448a68554199c47d08ffb10d4b8"
  end


  test "bin_slowsha works" do
    assert C.bin_slowsha('ab') == [198, 137, 247, 170, 30, 201, 185, 147, 177, 8, 32, 71, 144, 162, 245, 8, 100, 27, 223, 201, 106, 221, 1, 135, 229, 128, 210, 22, 162, 43, 75, 240]
  end

  # 
  # num_to_var_int tests
  #
  test "num_to_var_int case 0" do
    assert C.num_to_var_int(223) == [223]
  end

  test "num_to_var_int case 1" do
    assert C.num_to_var_int(340) == [253, 84, 1]
  end

  test "num_to_var_int case 2" do
    assert C.num_to_var_int(323524524) == [254, 172, 151, 72, 19]
  end

  test "num_to_var_int case 3" do
    assert C.num_to_var_int(78758749507438957) == [255, 109, 73, 88, 87, 170, 206, 23, 1]
  end

  # Electrum 
  test "Electrum siganiture" do
    assert C.electrum_sig_hash("Doh, this works!") == [218, 151, 143, 168, 255, 242, 248, 119, 32, 89, 19, 48, 98, 252, 192, 169, 190, 180, 151, 157, 152, 36, 88, 148, 207, 218, 6, 59, 28, 108, 214, 189] 
  end

  # 
  # ECDSA
  #

  @some_hash_msg "ae616f5c8f6d338e4905f6170a90a231d0c89470a94b28e894a83aef90975557"

  test "deterministic_generate_k correctness" do
    assert C.deterministic_generate_k(@some_hash_msg, @private_key_wif)
      == 56267843410105270424278661687405314302163735243946113335107965935995479810686
  end

  test "ecdsa_raw_sign" do
    assert C.ecdsa_raw_sign(@some_hash_msg, @private_key_wif) == {
      27,
      41154207482858914175911754278062463391398648683511312987539066225178600511219,
      53491489067854410808101337145682760178417845602912246581854164573336506079083
    }  
  end

  #
  # encoding and decoding basics
  #

  test "encode should work for base 256" do
    assert C.encode(@prime_70, 256) == [173, 51, 199, 177, 216, 177, 196, 183, 192, 150, 220, 234, 57, 145, 219, 154, 51, 37, 6, 178, 9, 206, 152, 144, 33, 128, 108, 106, 75]
  end

  test "encode should work for base 58" do
    assert C.encode(@prime_70, 58) == "8s3gRRbpi7NyJH3sudQTtsygDHDyzzB5q3Xc6svA"
  end

  test "encode should work for base 32" do
    assert C.encode(@prime_70, 32) == "cwthr5r3cy4jn6as3oouomr3ondgjigwie45geqegagy2sl"
  end

  test "encode should work for base 16" do
    assert C.encode(@prime_70, 16) == "ad33c7b1d8b1c4b7c096dcea3991db9a332506b209ce989021806c6a4b"
  end

  test "encode should work for base 10" do
    assert C.encode(@prime_70, 10) == "4669523849932130508876392554713407521319117239637943224980015676156491"
  end

  test "encode should work for base 2" do
    assert C.encode(@prime_20, 2) == "11111100101010110000110110010111001110001101001111111101010000101"
  end

  test "encode should work for 0 val" do
    assert C.encode(0, 58) == ""
  end

  test "decode should work for base 256" do
    chars = [173, 51, 199, 177, 216, 177, 196, 183, 192, 150, 220, 234, 57, 145, 219, 154, 51, 37, 6, 178, 9, 206, 152, 144, 33, 128, 108, 106, 75]
    assert C.decode(chars, 256) == @prime_70
  end

  test "decode should work for base 58" do
    assert C.decode("8s3gRRbpi7NyJH3sudQTtsygDHDyzzB5q3Xc6svA", 58) == @prime_70
  end

  test "decode should work for base 32" do
    assert C.decode("cwthr5r3cy4jn6as3oouomr3ondgjigwie45geqegagy2sl", 32) == @prime_70
  end

  test "decode should work for base 16" do
    assert C.decode("ad33c7b1d8b1c4b7c096dcea3991db9a332506b209ce989021806c6a4b", 16) == @prime_70
  end

  test "decode should work for base 10" do
    assert C.decode("4669523849932130508876392554713407521319117239637943224980015676156491", 10) == @prime_70
  end

  test "decode should work for base 2" do
    assert C.decode("11111100101010110000110110010111001110001101001111111101010000101", 2) == @prime_20
  end

  test "decode should work for empty string" do
    assert C.decode("", 58) == 0
  end

end

