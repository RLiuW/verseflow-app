import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_pt.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('pt')
  ];

  /// No description provided for @settingsTitle.
  ///
  /// In pt, this message translates to:
  /// **'Configurações'**
  String get settingsTitle;

  /// No description provided for @bibleSettingsTitle.
  ///
  /// In pt, this message translates to:
  /// **'Configurações da Bíblia'**
  String get bibleSettingsTitle;

  /// No description provided for @interfaceLanguageTitle.
  ///
  /// In pt, this message translates to:
  /// **'Idioma da interface'**
  String get interfaceLanguageTitle;

  /// No description provided for @languagePtBr.
  ///
  /// In pt, this message translates to:
  /// **'Português (pt-BR)'**
  String get languagePtBr;

  /// No description provided for @languageEnUs.
  ///
  /// In pt, this message translates to:
  /// **'English (en-US)'**
  String get languageEnUs;

  /// No description provided for @languageRestartHint.
  ///
  /// In pt, this message translates to:
  /// **'A mudança de idioma será aplicada ao reiniciar o app.'**
  String get languageRestartHint;

  /// No description provided for @restartAppTitle.
  ///
  /// In pt, this message translates to:
  /// **'Reiniciar app'**
  String get restartAppTitle;

  /// No description provided for @restartAppMessage.
  ///
  /// In pt, this message translates to:
  /// **'O idioma será aplicado ao reabrir o app.'**
  String get restartAppMessage;

  /// No description provided for @restartNow.
  ///
  /// In pt, this message translates to:
  /// **'Reiniciar agora'**
  String get restartNow;

  /// No description provided for @restartConfirmTitle.
  ///
  /// In pt, this message translates to:
  /// **'Reiniciar app'**
  String get restartConfirmTitle;

  /// No description provided for @restartConfirmBody.
  ///
  /// In pt, this message translates to:
  /// **'Deseja reiniciar o app agora para aplicar o idioma?'**
  String get restartConfirmBody;

  /// No description provided for @cancel.
  ///
  /// In pt, this message translates to:
  /// **'Cancelar'**
  String get cancel;

  /// No description provided for @yes.
  ///
  /// In pt, this message translates to:
  /// **'Sim'**
  String get yes;

  /// No description provided for @no.
  ///
  /// In pt, this message translates to:
  /// **'Não'**
  String get no;

  /// No description provided for @bible.
  ///
  /// In pt, this message translates to:
  /// **'Bíblia'**
  String get bible;

  /// No description provided for @signOut.
  ///
  /// In pt, this message translates to:
  /// **'Sair'**
  String get signOut;

  /// No description provided for @home.
  ///
  /// In pt, this message translates to:
  /// **'Início'**
  String get home;

  /// No description provided for @message.
  ///
  /// In pt, this message translates to:
  /// **'Mensagem'**
  String get message;

  /// No description provided for @live.
  ///
  /// In pt, this message translates to:
  /// **'Ao vivo'**
  String get live;

  /// No description provided for @warnings.
  ///
  /// In pt, this message translates to:
  /// **'Avisos'**
  String get warnings;

  /// No description provided for @signOutSuccess.
  ///
  /// In pt, this message translates to:
  /// **'Usuário deslogado com sucesso!'**
  String get signOutSuccess;

  /// No description provided for @defaultButton.
  ///
  /// In pt, this message translates to:
  /// **'Padrão'**
  String get defaultButton;

  /// No description provided for @save.
  ///
  /// In pt, this message translates to:
  /// **'Salvar'**
  String get save;

  /// No description provided for @settingsSaved.
  ///
  /// In pt, this message translates to:
  /// **'Dados personalizados salvos!'**
  String get settingsSaved;

  /// No description provided for @settingsReset.
  ///
  /// In pt, this message translates to:
  /// **'Dados resetados!'**
  String get settingsReset;

  /// No description provided for @fontSizeLabel.
  ///
  /// In pt, this message translates to:
  /// **'Tamanho da fonte:'**
  String get fontSizeLabel;

  /// No description provided for @bibleVersionLabel.
  ///
  /// In pt, this message translates to:
  /// **'Versão da Bíblia:'**
  String get bibleVersionLabel;

  /// No description provided for @adminModuleTitle.
  ///
  /// In pt, this message translates to:
  /// **'Módulo de\nAdministração\nVerseFlow'**
  String get adminModuleTitle;

  /// No description provided for @adminMessage.
  ///
  /// In pt, this message translates to:
  /// **'Mensagem'**
  String get adminMessage;

  /// No description provided for @adminWarning.
  ///
  /// In pt, this message translates to:
  /// **'Aviso'**
  String get adminWarning;

  /// No description provided for @adminLive.
  ///
  /// In pt, this message translates to:
  /// **'Ao Vivo'**
  String get adminLive;

  /// No description provided for @adminRegisters.
  ///
  /// In pt, this message translates to:
  /// **'Cadastros'**
  String get adminRegisters;

  /// No description provided for @adminUsers.
  ///
  /// In pt, this message translates to:
  /// **'Usuários'**
  String get adminUsers;

  /// No description provided for @administrator.
  ///
  /// In pt, this message translates to:
  /// **'Administrador'**
  String get administrator;

  /// No description provided for @addMessage.
  ///
  /// In pt, this message translates to:
  /// **'Adicionar Mensagem'**
  String get addMessage;

  /// No description provided for @title.
  ///
  /// In pt, this message translates to:
  /// **'Título'**
  String get title;

  /// No description provided for @messageLabel.
  ///
  /// In pt, this message translates to:
  /// **'Mensagem'**
  String get messageLabel;

  /// No description provided for @confirm.
  ///
  /// In pt, this message translates to:
  /// **'Confirmar'**
  String get confirm;

  /// No description provided for @addThisMessage.
  ///
  /// In pt, this message translates to:
  /// **'Adicionar esta Mensagem?'**
  String get addThisMessage;

  /// No description provided for @messageAddedSuccess.
  ///
  /// In pt, this message translates to:
  /// **'Mensagem adicionada com sucesso!'**
  String get messageAddedSuccess;

  /// No description provided for @noRegistrationRequests.
  ///
  /// In pt, this message translates to:
  /// **'Não há pedidos de cadastro!'**
  String get noRegistrationRequests;

  /// No description provided for @noUsersRegistered.
  ///
  /// In pt, this message translates to:
  /// **'Não há usuários registrados!'**
  String get noUsersRegistered;

  /// No description provided for @addLiveId.
  ///
  /// In pt, this message translates to:
  /// **'Adicionar ID de Live'**
  String get addLiveId;

  /// No description provided for @addWarning.
  ///
  /// In pt, this message translates to:
  /// **'Adicionar Aviso'**
  String get addWarning;

  /// No description provided for @date.
  ///
  /// In pt, this message translates to:
  /// **'Data'**
  String get date;

  /// No description provided for @time.
  ///
  /// In pt, this message translates to:
  /// **'Hora'**
  String get time;

  /// No description provided for @hello.
  ///
  /// In pt, this message translates to:
  /// **'Olá, '**
  String get hello;

  /// No description provided for @noNewMessages.
  ///
  /// In pt, this message translates to:
  /// **'Não há novas mensagens.'**
  String get noNewMessages;

  /// No description provided for @youHaveNewMessages.
  ///
  /// In pt, this message translates to:
  /// **'Você tem novas mensagens!'**
  String get youHaveNewMessages;

  /// No description provided for @noNewWarnings.
  ///
  /// In pt, this message translates to:
  /// **'Não há novos avisos.'**
  String get noNewWarnings;

  /// No description provided for @youHaveNewWarnings.
  ///
  /// In pt, this message translates to:
  /// **'Você tem novos avisos!'**
  String get youHaveNewWarnings;

  /// No description provided for @editMessage.
  ///
  /// In pt, this message translates to:
  /// **'Editar Mensagem'**
  String get editMessage;

  /// No description provided for @delete.
  ///
  /// In pt, this message translates to:
  /// **'Deletar'**
  String get delete;

  /// No description provided for @deleteThisMessage.
  ///
  /// In pt, this message translates to:
  /// **'Deletar esta Mensagem?'**
  String get deleteThisMessage;

  /// No description provided for @messageDeletedSuccess.
  ///
  /// In pt, this message translates to:
  /// **'Mensagem deletada com sucesso!'**
  String get messageDeletedSuccess;

  /// No description provided for @saveEditMessage.
  ///
  /// In pt, this message translates to:
  /// **'Salvar a edição desta Mensagem?'**
  String get saveEditMessage;

  /// No description provided for @messageEditedSuccess.
  ///
  /// In pt, this message translates to:
  /// **'Mensagem editada com sucesso!'**
  String get messageEditedSuccess;

  /// No description provided for @type.
  ///
  /// In pt, this message translates to:
  /// **'Tipo'**
  String get type;

  /// No description provided for @readVerses.
  ///
  /// In pt, this message translates to:
  /// **'Ler versículos'**
  String get readVerses;

  /// No description provided for @amen.
  ///
  /// In pt, this message translates to:
  /// **'Amém'**
  String get amen;

  /// No description provided for @total.
  ///
  /// In pt, this message translates to:
  /// **'Total'**
  String get total;

  /// No description provided for @editWarning.
  ///
  /// In pt, this message translates to:
  /// **'Editar Aviso'**
  String get editWarning;

  /// No description provided for @deleteThisWarning.
  ///
  /// In pt, this message translates to:
  /// **'Deletar este Aviso?'**
  String get deleteThisWarning;

  /// No description provided for @warningDeletedSuccess.
  ///
  /// In pt, this message translates to:
  /// **'Aviso deletado com sucesso!'**
  String get warningDeletedSuccess;

  /// No description provided for @saveEditWarning.
  ///
  /// In pt, this message translates to:
  /// **'Salvar a edição deste Aviso?'**
  String get saveEditWarning;

  /// No description provided for @warningEditedSuccess.
  ///
  /// In pt, this message translates to:
  /// **'Aviso editado com sucesso!'**
  String get warningEditedSuccess;

  /// No description provided for @themeTitle.
  ///
  /// In pt, this message translates to:
  /// **'Tema'**
  String get themeTitle;

  /// No description provided for @themeLight.
  ///
  /// In pt, this message translates to:
  /// **'Claro'**
  String get themeLight;

  /// No description provided for @themeDark.
  ///
  /// In pt, this message translates to:
  /// **'Escuro'**
  String get themeDark;

  /// No description provided for @themeSystem.
  ///
  /// In pt, this message translates to:
  /// **'Sistema'**
  String get themeSystem;

  /// No description provided for @fontSizeSmall.
  ///
  /// In pt, this message translates to:
  /// **'Pequena'**
  String get fontSizeSmall;

  /// No description provided for @fontSizeMedium.
  ///
  /// In pt, this message translates to:
  /// **'Média'**
  String get fontSizeMedium;

  /// No description provided for @fontSizeLarge.
  ///
  /// In pt, this message translates to:
  /// **'Grande'**
  String get fontSizeLarge;

  /// No description provided for @fontSizeLegend.
  ///
  /// In pt, this message translates to:
  /// **'Pequena    Média    Grande'**
  String get fontSizeLegend;

  /// No description provided for @bibleSacred.
  ///
  /// In pt, this message translates to:
  /// **'Bíblia Sagrada'**
  String get bibleSacred;

  /// No description provided for @bookTab.
  ///
  /// In pt, this message translates to:
  /// **'Livro'**
  String get bookTab;

  /// No description provided for @chapterTab.
  ///
  /// In pt, this message translates to:
  /// **'Capítulo'**
  String get chapterTab;

  /// No description provided for @verseTab.
  ///
  /// In pt, this message translates to:
  /// **'Versículo'**
  String get verseTab;

  /// No description provided for @chooseBookFirst.
  ///
  /// In pt, this message translates to:
  /// **'Favor escolher livro primeiro.'**
  String get chooseBookFirst;

  /// No description provided for @chooseBookAndChapterFirst.
  ///
  /// In pt, this message translates to:
  /// **'Favor escolher livro e capítulo primeiro.'**
  String get chooseBookAndChapterFirst;

  /// No description provided for @chooseChapterFirst.
  ///
  /// In pt, this message translates to:
  /// **'Favor escolher capítulo primeiro.'**
  String get chooseChapterFirst;

  /// No description provided for @invalidChapter.
  ///
  /// In pt, this message translates to:
  /// **'Capítulo inválido.'**
  String get invalidChapter;

  /// No description provided for @loginEmail.
  ///
  /// In pt, this message translates to:
  /// **'Email'**
  String get loginEmail;

  /// No description provided for @loginPassword.
  ///
  /// In pt, this message translates to:
  /// **'Senha'**
  String get loginPassword;

  /// No description provided for @loginButton.
  ///
  /// In pt, this message translates to:
  /// **'Entrar'**
  String get loginButton;

  /// No description provided for @forgotPassword.
  ///
  /// In pt, this message translates to:
  /// **'Esqueci minha senha.'**
  String get forgotPassword;

  /// No description provided for @signUpPrompt.
  ///
  /// In pt, this message translates to:
  /// **'Não possui uma conta? Cadastre-se!'**
  String get signUpPrompt;

  /// No description provided for @loginEmailInvalid.
  ///
  /// In pt, this message translates to:
  /// **'Por favor, insira um email válido.'**
  String get loginEmailInvalid;

  /// No description provided for @loginPasswordMinLength.
  ///
  /// In pt, this message translates to:
  /// **'A senha deve conter no mínimo 6 caracteres.'**
  String get loginPasswordMinLength;

  /// No description provided for @recoverySentMessage.
  ///
  /// In pt, this message translates to:
  /// **'Seu pedido de recuperação foi encaminhado para seu email!'**
  String get recoverySentMessage;

  /// No description provided for @enterEmailForRecovery.
  ///
  /// In pt, this message translates to:
  /// **'Insira seu email para recuperação.'**
  String get enterEmailForRecovery;

  /// No description provided for @loginLanguageLabel.
  ///
  /// In pt, this message translates to:
  /// **'Idioma'**
  String get loginLanguageLabel;

  /// No description provided for @openYoutubeApp.
  ///
  /// In pt, this message translates to:
  /// **'Abrir Youtube App'**
  String get openYoutubeApp;

  /// No description provided for @liveExampleUrl.
  ///
  /// In pt, this message translates to:
  /// **'Exemplo: www.youtube.com/watch?v='**
  String get liveExampleUrl;

  /// No description provided for @liveIdHint.
  ///
  /// In pt, this message translates to:
  /// **'Digite aqui o ID de video ao vivo.'**
  String get liveIdHint;

  /// No description provided for @liveIdMinLength.
  ///
  /// In pt, this message translates to:
  /// **'O ID de Live precisa ter no mínimo 11 caracteres.'**
  String get liveIdMinLength;

  /// No description provided for @signUpNameHint.
  ///
  /// In pt, this message translates to:
  /// **'Nome'**
  String get signUpNameHint;

  /// No description provided for @signUpNameError.
  ///
  /// In pt, this message translates to:
  /// **'Por favor, insira seu nome completo.'**
  String get signUpNameError;

  /// No description provided for @signUpButton.
  ///
  /// In pt, this message translates to:
  /// **'Entrar'**
  String get signUpButton;

  /// No description provided for @signUpLoginPrompt.
  ///
  /// In pt, this message translates to:
  /// **'Já possui uma conta? Faça o login!'**
  String get signUpLoginPrompt;

  /// No description provided for @signUpTitle.
  ///
  /// In pt, this message translates to:
  /// **'Cadastro'**
  String get signUpTitle;

  /// No description provided for @signUpSuccessMessage.
  ///
  /// In pt, this message translates to:
  /// **'Pedido de cadastro realizado com sucesso! Aguarde resposta do administrador.'**
  String get signUpSuccessMessage;

  /// No description provided for @signUpDuplicateEmailMessage.
  ///
  /// In pt, this message translates to:
  /// **'Já existe um pedido de cadastro com o email digitado. Por favor, aguarde uma resposta do administrador.'**
  String get signUpDuplicateEmailMessage;

  /// No description provided for @signUpClose.
  ///
  /// In pt, this message translates to:
  /// **'Fechar'**
  String get signUpClose;

  /// No description provided for @deleteRegistration.
  ///
  /// In pt, this message translates to:
  /// **'Deletar cadastro'**
  String get deleteRegistration;

  /// No description provided for @saveRegistration.
  ///
  /// In pt, this message translates to:
  /// **'Salvar cadastro'**
  String get saveRegistration;

  /// No description provided for @deleteUser.
  ///
  /// In pt, this message translates to:
  /// **'Deletar usuário'**
  String get deleteUser;

  /// No description provided for @registrationAccepted.
  ///
  /// In pt, this message translates to:
  /// **'Cadastro aceito com sucesso!'**
  String get registrationAccepted;

  /// No description provided for @registrationRejected.
  ///
  /// In pt, this message translates to:
  /// **'Cadastro rejeitado!'**
  String get registrationRejected;

  /// No description provided for @errorAccepting.
  ///
  /// In pt, this message translates to:
  /// **'Erro ao aceitar cadastro: {error}'**
  String errorAccepting(String error);

  /// No description provided for @errorDeleting.
  ///
  /// In pt, this message translates to:
  /// **'Erro ao deletar: {error}'**
  String errorDeleting(String error);

  /// No description provided for @userDeleted.
  ///
  /// In pt, this message translates to:
  /// **'Usuário deletado!'**
  String get userDeleted;

  /// No description provided for @confirmDelete.
  ///
  /// In pt, this message translates to:
  /// **'Confirma deletar este usuário?'**
  String get confirmDelete;

  /// No description provided for @confirmDeleteRegistration.
  ///
  /// In pt, this message translates to:
  /// **'Deletar este cadastro?'**
  String get confirmDeleteRegistration;

  /// No description provided for @confirmCreateUser.
  ///
  /// In pt, this message translates to:
  /// **'Criar este usuário?'**
  String get confirmCreateUser;

  /// No description provided for @yesDelete.
  ///
  /// In pt, this message translates to:
  /// **'Sim, deletar'**
  String get yesDelete;

  /// No description provided for @nameLabel.
  ///
  /// In pt, this message translates to:
  /// **'Nome'**
  String get nameLabel;

  /// No description provided for @closeButton.
  ///
  /// In pt, this message translates to:
  /// **'Fechar'**
  String get closeButton;

  /// No description provided for @cadastroEnviado.
  ///
  /// In pt, this message translates to:
  /// **'Cadastro enviado! Aguarde aprovação do administrador.'**
  String get cadastroEnviado;

  /// No description provided for @registrationPendingApproval.
  ///
  /// In pt, this message translates to:
  /// **'Seu cadastro está pendente de aprovação. Aguarde.'**
  String get registrationPendingApproval;

  /// No description provided for @pendenteTitle.
  ///
  /// In pt, this message translates to:
  /// **'Aguardando Aprovação'**
  String get pendenteTitle;

  /// No description provided for @pendenteMessage.
  ///
  /// In pt, this message translates to:
  /// **'Seu cadastro ainda está pendente de aprovação pelo administrador. Você será desconectado.'**
  String get pendenteMessage;

  /// No description provided for @okButton.
  ///
  /// In pt, this message translates to:
  /// **'OK'**
  String get okButton;

  /// No description provided for @liveLoadError.
  ///
  /// In pt, this message translates to:
  /// **'Não foi possível carregar o conteúdo ao vivo. Tente novamente mais tarde.'**
  String get liveLoadError;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'pt'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'pt':
      return AppLocalizationsPt();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
