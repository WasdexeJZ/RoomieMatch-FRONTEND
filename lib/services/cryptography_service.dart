import 'dart:convert';
import 'dart:typed_data';
import 'dart:math';

import 'package:pointycastle/export.dart';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:basic_utils/basic_utils.dart';

class CryptographyService {
  static void initRSA() {}

  static RSAPublicKey generateRSAKeyPair() {
    Random random = Random.secure();
    List<int> seeds = List<int>.generate(32, (_) => random.nextInt(256));

    FortunaRandom secureRandom = FortunaRandom();
    secureRandom.seed(KeyParameter(Uint8List.fromList(seeds)));

    RSAKeyGenerator keyGen = RSAKeyGenerator()..init(ParametersWithRandom(RSAKeyGeneratorParameters(BigInt.parse('65537'), 2048, 64), secureRandom));

    final AsymmetricKeyPair<PublicKey, PrivateKey> keyPair = keyGen.generateKeyPair();

    RSAPublicKey publicKey = keyPair.publicKey as RSAPublicKey;
    RSAPrivateKey privateKey = keyPair.privateKey as RSAPrivateKey;

    String privateKeyPEM = CryptoUtils.encodeRSAPrivateKeyToPem(privateKey);

    secureStore("private_key", privateKeyPEM);

    return publicKey;
  }

  static void secureStore(String storeKey, String privateKey) async {
    final storage = FlutterSecureStorage();
    // const String storekey = "private_key";

    await storage.write(key: storeKey, value: privateKey);
  }

  static Future<String> secureRead() async {
    final storage = FlutterSecureStorage();
    const String storeKey = "private_key";

    return (await storage.read(key: storeKey) ?? "");
  }

  static void sendPublicKey() async {}

  // static Uint8List rsaDecrypt(RSAPrivateKey myPrivate, Uint8List cipherText) {
  //   final decryptor = OAEPEncoding(RSAEngine())..init(false, PrivateKeyParameter<RSAPrivateKey>(myPrivate)); // false=decrypt

  //   return _processInBlocks(decryptor, cipherText);
  // }

  // static Uint8List _processInBlocks(AsymmetricBlockCipher engine, Uint8List input) {
  //   final numBlocks = input.length ~/ engine.inputBlockSize + ((input.length % engine.inputBlockSize != 0) ? 1 : 0);

  //   final output = Uint8List(numBlocks * engine.outputBlockSize);

  //   var inputOffset = 0;
  //   var outputOffset = 0;
  //   while (inputOffset < input.length) {
  //     final chunkSize = (inputOffset + engine.inputBlockSize <= input.length) ? engine.inputBlockSize : input.length - inputOffset;

  //     outputOffset += engine.processBlock(input, inputOffset, chunkSize, output, outputOffset);

  //     inputOffset += chunkSize;
  //   }

  //   return (output.length == outputOffset) ? output : output.sublist(0, outputOffset);
  // }
}
