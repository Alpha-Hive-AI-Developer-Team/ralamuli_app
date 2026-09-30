import 'package:flutter_test/flutter_test.dart';
import 'package:ralamuli_translator/core/Utils/search_normalizer.dart';
import 'package:ralamuli_translator/core/data/translation_entries.dart';
import 'package:ralamuli_translator/core/database/dictionary_database.dart';
import 'package:ralamuli_translator/core/database/dictionary_repository.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late DictionaryRepository repository;

  setUpAll(() async {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
    await databaseFactory.deleteDatabase(
      '${await getDatabasesPath()}/raramuri_dictionary.db',
    );
    repository = DictionaryRepository(DictionaryDatabase.instance);
    await repository.initialize();
  });

  Future<String?> translate(String input, String from, String to) async {
    final entry = await repository.searchEntry(
      sourceLanguage: from,
      input: input,
    );
    return entry?.textForLanguage(to);
  }

  group('normalizeForSearch', () {
    test('ignores case, accents and punctuation', () {
      expect(normalizeForSearch('¡Pay Attention!'), 'pay attention');
      expect(normalizeForSearch('Rarámuri'), 'raramuri');
      expect(normalizeForSearch('ba´wí'), "ba'wi");
      expect(normalizeForSearch('Wait still! / Keep waiting!'),
          'wait still keep waiting');
    });
  });

  group('English to Rarámuri', () {
    const en = AppLanguages.english;
    const ra = AppLanguages.ralamuli;

    test('phrases reported as "translation not found"', () async {
      expect(await translate('pay attention', en, ra), '¡nijiyá!');
      expect(await translate('Pay attention!', en, ra), '¡nijiyá!');
      expect(await translate('Wait still! / Keep waiting!', en, ra),
          '¡abijí buwésa!');
      expect(await translate('wait still', en, ra), '¡abijí buwésa!');
      expect(await translate('keep waiting', en, ra), '¡abijí buwésa!');
    });

    test('alternatives and infinitives', () async {
      expect(await translate('amen', en, ra), '¡echiregá níraga!');
      expect(await translate('step aside', en, ra), '¡echomí!');
      expect(await translate('goodbye', en, ra), '¡ariósibá!');
      expect(await translate('sit down', en, ra), '¡chopona asá!');
    });

    test('unknown text still returns null', () async {
      expect(await translate('zzqx', en, ra), isNull);
      expect(await translate('!!!', en, ra), isNull);
    });
  });

  group('other directions', () {
    test('Spanish without accents', () async {
      expect(await translate('adios', AppLanguages.espanol, AppLanguages.english),
          'Goodbye!');
      expect(
          await translate(
              'pon atencion', AppLanguages.espanol, AppLanguages.ralamuli),
          '¡nijiyá!');
    });

    test('Rarámuri variants and apostrophe styles', () async {
      expect(
          await translate('nibira', AppLanguages.ralamuli, AppLanguages.english),
          'Look! / Pay attention!');
      expect(
          await translate('kasina', AppLanguages.ralamuli, AppLanguages.english),
          'to break');
      expect(
          await translate(
              'abiji buwesa', AppLanguages.ralamuli, AppLanguages.english),
          'Wait still! / Keep waiting!');
    });
  });
}
