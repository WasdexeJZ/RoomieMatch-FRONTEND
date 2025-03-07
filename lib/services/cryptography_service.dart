import 'dart:convert';
import 'dart:typed_data';
import 'dart:math';

import 'package:pointycastle/export.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:basic_utils/basic_utils.dart';

import 'api_service.dart';

class CryptographyService {
  static final ApiService apiService = ApiService();

  static Future<void> initRSA() async {
    AsymmetricKeyPair<RSAPublicKey, RSAPrivateKey> keyPair = generateRSAKeyPair();

    // Convert RSAPrivateKey to PEM format and store to secureStorage
    String privateKeyPEM = CryptoUtils.encodeRSAPrivateKeyToPem(keyPair.privateKey);
    await secureWrite("private_key", privateKeyPEM);

    // Send public key to backend to encrypt
    String publicKeyPEM = CryptoUtils.encodeRSAPublicKeyToPem(keyPair.publicKey);
    await sendPublicKey(publicKeyPEM);
  }

  static AsymmetricKeyPair<RSAPublicKey, RSAPrivateKey> generateRSAKeyPair() {
    // Generate secureRandom object to be used for KeyPair generation
    Random random = Random.secure();
    List<int> seeds = List<int>.generate(32, (_) => random.nextInt(256));

    FortunaRandom secureRandom = FortunaRandom();
    secureRandom.seed(KeyParameter(Uint8List.fromList(seeds)));

    // Generate key pair with RSAKeyGenerator and secureRandom object
    RSAKeyGenerator keyGen = RSAKeyGenerator()..init(ParametersWithRandom(RSAKeyGeneratorParameters(BigInt.parse('65537'), 2048, 64), secureRandom));

    final AsymmetricKeyPair<PublicKey, PrivateKey> keyPair = keyGen.generateKeyPair();

    // Cast key pair to Public and Private Key types
    RSAPublicKey publicKey = keyPair.publicKey as RSAPublicKey;
    RSAPrivateKey privateKey = keyPair.privateKey as RSAPrivateKey;

    return AsymmetricKeyPair<RSAPublicKey, RSAPrivateKey>(publicKey, privateKey);
  }

  // Securely write to SecureStorage using storageKey
  static Future<void> secureWrite(String storageKey, String value) async {
    final storage = FlutterSecureStorage();

    await storage.write(key: storageKey, value: value);
  }

  // Securely read from SecureStorage using storageKey
  static Future<String> secureRead(String storageKey) async {
    final storage = FlutterSecureStorage();

    return (await storage.read(key: storageKey) ?? "");
  }

  // Repeatedly try to send public key to backend to save to database
  static Future<void> sendPublicKey(String publicKey) async {
    String apiResponseStatus;
    bool isIteration = false;

    do {
      Map<String, dynamic> publicKeyMap = {"value": ""};

      publicKeyMap['value'] = publicKey;

      Map<String, dynamic> apiResponse = await apiService.post('db/update-user-public-key/', publicKeyMap);

      apiResponseStatus = apiResponse['status'];

      if (isIteration) {
        await Future.delayed(Duration(seconds: 30));
      }

      isIteration = true;
    } while (apiResponseStatus == 'ERROR' || apiResponseStatus == 'UNKNOWN');
  }

  static Future<String> decryptRSA(String cipherText) async {
    // Get private key from secure storage
    RSAPrivateKey privateKey = CryptoUtils.rsaPrivateKeyFromPem(await secureRead("private_key"));

    // Decode string from backend to bytes
    Uint8List cipherBytes = base64Decode(cipherText);

    // Initialize RSA with OAEP SHA-256 padding
    OAEPEncoding decryptor = OAEPEncoding(RSAEngine())..init(false, PrivateKeyParameter<RSAPrivateKey>(privateKey));

    // Decrypt the message
    Uint8List decryptedBytes = decryptor.process(cipherBytes);

    // Convert decrypted bytes to string (UTF-8)
    String decryptedString = utf8.decode(decryptedBytes);

    return decryptedString;
  }
}
