import 'dart:convert';
import 'dart:typed_data';
import 'dart:math';

import 'package:RoomieMatch/services/message_key_db_service.dart';
import 'package:intl/intl.dart';
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

  static Future<void> test() async {
    String te = "output should be ok";

    int keyId = 0;
    print("te");
    print(te);
    AsymmetricKeyPair<RSAPublicKey, RSAPrivateKey> keyPair = CryptographyService.generateRSAKeyPair();

    // Convert RSAPrivateKey to PEM format and store to secureStorage
    String privateKeyPEM = CryptoUtils.encodeRSAPrivateKeyToPem(keyPair.privateKey);
    await MessageKeyDBService().insertMessageKey(keyId, privateKeyPEM);

    String publicKeyPEM = CryptoUtils.encodeRSAPublicKeyToPem(keyPair.publicKey);
    await CryptographyService.sendPublicMessageKey(publicKeyPEM, keyId);

    Map<String, dynamic> apiResponse = await apiService.get('messaging/get-messaging-public-key/?user_id=2c5d106e-7401-4468-b264-bc6db2559391');

    String cipher = await CryptographyService.encryptMessage(apiResponse['publicKey'], te);
    print("cipher");
    print(cipher);

    Map<String, dynamic> messageMap = {"recipientUserId": "", "cipherText": "", "keyId": -1, "timestamp": ""};

    String timestamp = DateFormat('yyyy-MM-ddTHH:mm:ss').format(DateTime.now());

    messageMap['recipientUserId'] = "2c5d106e-7401-4468-b264-bc6db2559391";
    messageMap['cipherText'] = cipher;
    messageMap['keyId'] = apiResponse['keyId'];
    messageMap['timestamp'] = timestamp;

    Map<String, dynamic> dum = await apiService.post('messaging/send-messages/', messageMap);

    final List<Map<String, dynamic>> keyResponse = await MessageKeyDBService().getMessagesPrivateKeyById(apiResponse['keyId']);

    String back = await CryptographyService.decryptMessage(keyResponse[0]['private_key'], cipher);
    print("decipher");
    print(back);
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

  static Future<void> sendPublicMessageKey(String publicKey, int keyId) async {
    String apiResponseStatus;
    bool isIteration = false;

    do {
      Map<String, dynamic> publicKeyMap = {"publicKey": "", "keyId": -1};

      publicKeyMap['publicKey'] = publicKey;
      publicKeyMap['keyId'] = keyId;

      Map<String, dynamic> apiResponse = await apiService.post('messaging/update-messaging-public-key/', publicKeyMap);

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

  static Future<String> encryptMessage(String publicKeyPEM, String plainText) async {
    // Get public key from parameter
    RSAPublicKey publicKey = CryptoUtils.rsaPublicKeyFromPem(publicKeyPEM);

    // Decode string from text to bytes
    Uint8List plainBytes = utf8.encode(plainText);
    // Uint8List cipherBytes = base64Decode(cipherText);

    // Initialize RSA with OAEP SHA-256 padding
    OAEPEncoding encryptor = OAEPEncoding(RSAEngine())..init(true, PublicKeyParameter<RSAPublicKey>(publicKey));

    // Encrypt the message
    Uint8List encryptedBytes = encryptor.process(plainBytes);

    // Convert encrypted bytes to string (base64)
    String encryptedString = base64Encode(encryptedBytes);

    return encryptedString;
  }

  static Future<String> decryptMessage(String privateKeyPEM, String cipherText) async {
    // Get private key from parameter
    RSAPrivateKey privateKey = CryptoUtils.rsaPrivateKeyFromPem(privateKeyPEM);

    // Decode string from text to bytes
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
