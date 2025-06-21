import '../models/module_model.dart';
import '../models/theme_model.dart';
import '../models/article_model.dart';
import '../models/article_component_model.dart';
import '../models/ai_conversation_model.dart';

class MockData {
  // Sample modules
  static List<ModuleModel> get modules => [
    ModuleModel(
      id: '1',
      title: 'Rus alifbosi',
      description: 'Kirill yozuvi va rus harflarini o\'rganish',
      icon: '🔤',
      level: 'beginner',
      themeCount: 6,
      category: 'basics',
      uzbekDescription: 'Rus tilining asosi - 33 ta harfni o\'rganamiz',
      progress: 0.3,
    ),

    ModuleModel(
      id: '2',
      title: 'Tanishuv va salomlashuv',
      description: 'Oddiy rus tilida salomlashish va tanishish',
      icon: '👋',
      level: 'beginner',
      themeCount: 8,
      category: 'conversation',
      uzbekDescription: 'Har kuni ishlatiladigan salomlashuv so\'zlari',
      progress: 0.0,
    ),

    ModuleModel(
      id: '3',
      title: 'Raqamlar va vaqt',
      description: 'Rus tilida raqamlar, kunlar va vaqt',
      icon: '🔢',
      level: 'beginner',
      themeCount: 10,
      category: 'vocabulary',
      uzbekDescription: 'Kundalik hayotda kerak bo\'ladigan raqamlar',
      progress: 0.0,
    ),

    ModuleModel(
      id: '4',
      title: 'Rang va shakl',
      description: 'Turli ranglar va shakllarni ifodalash',
      icon: '🎨',
      level: 'beginner',
      themeCount: 7,
      category: 'vocabulary',
      uzbekDescription: 'Atrofimizdagi narsalarni tasvirlash uchun',
      progress: 0.0,
    ),

    ModuleModel(
      id: '5',
      title: 'Uy va oila',
      description: 'Oila a\'zolari va uy jihozlari',
      icon: '🏠',
      level: 'intermediate',
      themeCount: 12,
      category: 'vocabulary',
      uzbekDescription: 'Oila va uy haqida gaplashish',
      progress: 0.0,
      isLocked: true,
      prerequisites: ['1', '2'],
    ),

    ModuleModel(
      id: '6',
      title: 'Grammatika asoslari',
      description: 'Rus tili grammatikasining asosiy qoidalari',
      icon: '📝',
      level: 'intermediate',
      themeCount: 15,
      category: 'grammar',
      uzbekDescription: 'To\'g\'ri gapirish uchun grammatika qoidalari',
      progress: 0.0,
      isLocked: true,
      prerequisites: ['1', '2', '3'],
    ),
  ];

  // Sample themes for the first module
  static List<ThemeModel> get themes => [
    // Module 1: Rus alifbosi
    ThemeModel(
      id: '1_1',
      moduleId: '1',
      title: 'А, Б, В harflari',
      subtitle: 'Rus alifbosining birinchi harflari',
      duration: '10 daqiqa',
      difficulty: 1,
      articleId: 'article_abc',
      order: 1,
      isCompleted: true,
      uzbekSummary: 'А (а), Б (бэ), В (вэ) harflari va ularning talaffuzi',
      keywords: ['А', 'Б', 'В', 'авто', 'бабушка', 'вода'],
    ),

    ThemeModel(
      id: '1_2',
      moduleId: '1',
      title: 'Г, Д, Е harflari',
      subtitle: 'Keyingi harflar va oddiy so\'zlar',
      duration: '12 daqiqa',
      difficulty: 1,
      articleId: 'article_gde',
      order: 2,
      isCompleted: true,
      uzbekSummary: 'Г (гэ), Д (дэ), Е (е) harflari bilan tanishish',
      keywords: ['Г', 'Д', 'Е', 'город', 'дом', 'есть'],
    ),

    ThemeModel(
      id: '1_3',
      moduleId: '1',
      title: 'Ё, Ж, З harflari',
      subtitle: 'Murakkab tovushlar va talaffuz',
      duration: '15 daqiqa',
      difficulty: 2,
      articleId: 'article_ejz',
      order: 3,
      uzbekSummary: 'Ё (ё), Ж (жэ), З (зэ) - qiyin talaffuz qilinadigan harflar',
      keywords: ['Ё', 'Ж', 'З', 'ёлка', 'жизнь', 'знать'],
    ),

    ThemeModel(
      id: '1_4',
      moduleId: '1',
      title: 'И, Й, К harflari',
      subtitle: 'Kichik va katta harflar',
      duration: '10 daqiqa',
      difficulty: 1,
      articleId: 'article_ijk',
      order: 4,
      uzbekSummary: 'И (и), Й (и краткое), К (ка) harflari',
      keywords: ['И', 'Й', 'К', 'имя', 'мой', 'как'],
    ),

    ThemeModel(
      id: '1_5',
      moduleId: '1',
      title: 'Л, М, Н harflari',
      subtitle: 'Sodda so\'zlar yasash',
      duration: '12 daqiqa',
      difficulty: 1,
      articleId: 'article_lmn',
      order: 5,
      uzbekSummary: 'Л (эль), М (эм), Н (эн) harflari va so\'z yasash',
      keywords: ['Л', 'М', 'Н', 'любить', 'мама', 'нет'],
    ),

    ThemeModel(
      id: '1_6',
      moduleId: '1',
      title: 'Alifbo takrorlash',
      subtitle: 'Barcha harflarni eslab qolish',
      duration: '20 daqiqa',
      difficulty: 2,
      articleId: 'article_review',
      order: 6,
      uzbekSummary: 'Butun rus alifbosini takrorlash va mustahkamlash',
      keywords: ['алфавит', 'буквы', 'чтение', 'произношение'],
    ),

    // Module 2: Tanishuv va salomlashuv
    ThemeModel(
      id: '2_1',
      moduleId: '2',
      title: 'Привет! - Salom!',
      subtitle: 'Asosiy salomlashuv so\'zlari',
      duration: '8 daqiqa',
      difficulty: 1,
      articleId: 'article_hello',
      order: 1,
      uzbekSummary: 'Turli vaqtlarda qanday salomlashish kerak',
      keywords: ['Привет', 'Здравствуйте', 'Доброе утро', 'Добрый день'],
    ),

    ThemeModel(
      id: '2_2',
      moduleId: '2',
      title: 'Как дела? - Ishlar qanday?',
      subtitle: 'Ahvol so\'rash va javob berish',
      duration: '10 daqiqa',
      difficulty: 1,
      articleId: 'article_how_are_you',
      order: 2,
      uzbekSummary: 'Ahvol so\'rash va turli javoblar berish usullari',
      keywords: ['Как дела?', 'Хорошо', 'Плохо', 'Нормально'],
    ),
  ];

  // Sample detailed article for the alphabet
  static ArticleModel get sampleArticle => ArticleModel(
    id: 'article_abc',
    title: 'Rus alifbosining birinchi harflari: А, Б, В',
    subtitle: 'Kirill yozuvining asoslarini o\'rganamiz',
    components: [
      ArticleComponentModel.heading(
        id: 'intro_heading',
        text: 'Rus alifbosi bilan tanishuv',
        level: 1,
      ),

      ArticleComponentModel.text(
        id: 'intro_text',
        text: 'Rus tili 33 ta harfdan iborat Kirill alifbosidan foydalanadi. Bu alifbo slavyan xalqlari tomonidan keng qo\'llaniladi. Bugun biz birinchi uch harfni o\'rganamiz.',
      ),

      ArticleComponentModel.heading(
        id: 'letter_a_heading',
        text: 'А (а) - "А" harfi',
        level: 2,
      ),

      ArticleComponentModel.text(
        id: 'letter_a_text',
        text: 'Rus tilida "А" harfi xuddi o\'zbek tilidagi kabi "а" tovushi bilan talaffuz qilinadi. Bu unlilar ichida eng oddiysi.',
      ),

      ArticleComponentModel.quote(
        id: 'letter_a_example',
        text: 'А - это первая буква русского алфавита',
        author: 'Rus maqoli',
      ),

      ArticleComponentModel.table(
        id: 'letter_examples',
        headers: ['Harf', 'Talaffuz', 'Misol so\'z', 'Ma\'nosi'],
        data: [
          ['А', 'а', 'авто', 'mashina'],
          ['Б', 'бэ', 'бабушка', 'buvi'],
          ['В', 'вэ', 'вода', 'suv'],
        ],
        caption: 'Birinchi uch harf va misol so\'zlar',
      ),

      ArticleComponentModel.heading(
        id: 'pronunciation_heading',
        text: 'Talaffuz qoidalari',
        level: 2,
      ),

      ArticleComponentModel.list(
        id: 'pronunciation_rules',
        title: 'Muhim talaffuz qoidalari:',
        items: [
          'А harfi har doim aniq "а" deb talaffuz qilinadi',
          'Б harfi ingliz tilida "b" kabi, lekin biroz yumshoqroq',
          'В harfi ingliz tilida "v" kabi, ammo biroz kuchliroq',
          'Har bir harfning o\'z nomi va tovushi bor',
        ],
        isOrdered: true,
      ),

      ArticleComponentModel.quote(
        id: 'learning_tip',
        text: 'Har kuni 10 daqiqa mashq qiling - bu yaxshi natija beradi!',
        author: 'Til o\'rganish maslahati',
      ),

      ArticleComponentModel.heading(
        id: 'practice_heading',
        text: 'Amaliy mashqlar',
        level: 2,
      ),

      ArticleComponentModel.text(
        id: 'practice_text',
        text: 'Endi siz bu harflarni yozish va talaffuz qilishni mashq qiling. Quyidagi so\'zlarni ovoz chiqarib o\'qib ko\'ring:',
      ),

      ArticleComponentModel.code(
        id: 'practice_words',
        code: 'А-а-а... (cho\'zilgan tovush)\nАвто (avto) - mashina\nБабушка (babushka) - buvi\nВода (voda) - suv\nВасилий (Vasiliy) - erkak ismi',
        language: 'text',
        title: 'Talaffuz mashqi',
      ),

      ArticleComponentModel.divider(id: 'divider_1'),

      ArticleComponentModel.heading(
        id: 'uzbek_explanation_heading',
        text: 'O\'zbek tilida tushuntirish',
        level: 2,
      ),

      ArticleComponentModel.text(
        id: 'uzbek_explanation',
        text: 'Bu harflar o\'zbek alifbosidagi harflarga juda o\'xshash. А harfi bir xil, Б ham deyarli bir xil, faqat В harfi o\'zbek tilida "V" deb yoziladi, rus tilida esa "В" shaklida yoziladi.',
      ),

      ArticleComponentModel.image(
        id: 'alphabet_image',
        url: 'https://example.com/russian_alphabet.jpg',
        caption: 'Rus alifbosining birinchi qismi',
        alt: 'Rus harflari А, Б, В ning rasmi',
      ),

      ArticleComponentModel.heading(
        id: 'homework_heading',
        text: 'Uy vazifasi',
        level: 2,
      ),

      ArticleComponentModel.list(
        id: 'homework_list',
        title: 'Keyingi darsga tayyorgarlik:',
        items: [
          'А, Б, В harflarini 5 marta yozing',
          'Har bir harfning nomini eslab qoling',
          'Misol so\'zlarni 3 marta takrorlang',
          'Talaffuzni tekshirish uchun audio yozuv tinglang',
        ],
        isOrdered: true,
      ),
    ],
    metadata: ArticleMetadata(
      author: 'Rus tili o\'qituvchisi',
      readTime: '10 daqiqa',
      level: 'beginner',
      tags: ['alifbo', 'harflar', 'talaffuz', 'boshlang\'ich'],
      publishDate: DateTime.now().subtract(const Duration(days: 7)),
      lastUpdated: DateTime.now().subtract(const Duration(days: 1)),
      uzbekExplanation: 'Bu dars rus alifbosining eng muhim qismi bo\'lgan birinchi uch harfni o\'rgatadi. O\'zbek tilida yaxshi tushuntirilgan.',
    ),
  );

  // Sample AI conversation
  static List<AIConversationModel> get sampleConversation => [
    AIConversationModel.userMessage(
      message: 'Привет! Как дела?',
    ),

    AIConversationModel.aiMessage(
      message: 'Привет! У меня всё хорошо, спасибо! А как у тебя дела? Как проходит изучение русского языка?',
    ),

    AIConversationModel.userMessage(
      message: 'Хорошо изучаю. Можешь объяснить разницу между "ты" и "вы"?',
    ),

    AIConversationModel.aiMessage(
      message: 'Конечно! "Ты" - это неформальное обращение к одному человеку, которого ты хорошо знаешь. "Вы" используется в формальных ситуациях или при обращении к нескольким людям. Например: "Мама, ты дома?" но "Извините, вы не подскажете время?"',
    ),
  ];

  // Get themes by module ID
  static List<ThemeModel> getThemesByModuleId(String moduleId) {
    return themes.where((theme) => theme.moduleId == moduleId).toList()
      ..sort((a, b) => a.order.compareTo(b.order));
  }

  // Get module by ID
  static ModuleModel? getModuleById(String id) {
    try {
      return modules.firstWhere((module) => module.id == id);
    } catch (e) {
      return null;
    }
  }

  // Get article by ID
  static ArticleModel? getArticleById(String id) {
    // For now, return the sample article for any ID
    // In real app, this would fetch from database/API
    return sampleArticle;
  }

  // Get theme by ID
  static ThemeModel? getThemeById(String id) {
    try {
      return themes.firstWhere((theme) => theme.id == id);
    } catch (e) {
      return null;
    }
  }
}