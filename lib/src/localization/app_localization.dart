import 'package:flutter/material.dart';

enum AppLanguage { ptBr, en }

class AppLanguageController extends ChangeNotifier {
  AppLanguageController([this._language = AppLanguage.ptBr]);

  AppLanguage _language;

  AppLanguage get language => _language;

  Locale get locale =>
      _language == AppLanguage.ptBr ? const Locale('pt', 'BR') : const Locale('en');

  void setLanguage(AppLanguage language) {
    if (_language == language) {
      return;
    }
    _language = language;
    notifyListeners();
  }
}

class AppLanguageScope extends InheritedNotifier<AppLanguageController> {
  const AppLanguageScope({
    super.key,
    required AppLanguageController controller,
    required super.child,
  }) : super(notifier: controller);

  static AppLanguageController of(BuildContext context) {
    final scope =
        context.dependOnInheritedWidgetOfExactType<AppLanguageScope>();
    assert(scope != null, 'AppLanguageScope not found in widget tree.');
    return scope!.notifier!;
  }
}

class AppStrings {
  const AppStrings(this.language);

  final AppLanguage language;

  bool get isPtBr => language == AppLanguage.ptBr;

  String get appTitle => 'CustomFlix';
  String get admin => isPtBr ? 'Admin' : 'Admin';
  String get logoutFallback => isPtBr ? 'Sair' : 'Sign out';
  String get seriesTitle => isPtBr ? 'Séries' : 'Series';
  String get searchSeriesHint => isPtBr
      ? 'Buscar série por título ou descrição'
      : 'Search series by title or description';
  String get noSeriesYet =>
      isPtBr ? 'Nenhuma série cadastrada ainda.' : 'No series added yet.';
  String noSeriesFound(String query) => isPtBr
      ? 'Nenhuma série encontrada para "$query".'
      : 'No series found for "$query".';
  String get signInIntro => isPtBr
      ? 'Entre com sua conta Google para assistir. A área administrativa é restrita ao e-mail autorizado.'
      : 'Sign in with your Google account to watch. The admin area is restricted to the authorized email.';
  String get signInWithGoogle =>
      isPtBr ? 'Entrar com Google' : 'Continue with Google';
  String get signingIn => isPtBr ? 'Entrando...' : 'Signing in...';
  String signInError(Object error) =>
      isPtBr ? 'Falha no login Google: $error' : 'Google sign-in failed: $error';
  String get episodes => isPtBr ? 'Episódios' : 'Episodes';
  String get noVideosInSeries => isPtBr
      ? 'Sem vídeos cadastrados para esta série.'
      : 'No videos have been added to this series yet.';
  String get noDescription =>
      isPtBr ? 'Sem descrição.' : 'No description.';
  String get originalLinkLabel =>
      isPtBr ? 'Link original' : 'Original link';
  String get driveFolderLabel =>
      isPtBr ? 'Pasta Drive' : 'Drive folder';
  String get playerOnlyWeb => isPtBr
      ? 'Player de vídeo disponível apenas no Flutter Web.'
      : 'Video player is only available on Flutter Web.';
  String get adminCatalogTitle =>
      isPtBr ? 'Admin - Catálogo' : 'Admin - Catalog';
  String get restrictedAdminAccess => isPtBr
      ? 'Acesso restrito ao administrador.'
      : 'Access restricted to the administrator.';
  String get syncInfo => isPtBr
      ? 'Ao salvar uma série, o backend sincroniza a pasta do Google Drive, mapeia os vídeos em episódios e tenta preencher as thumbnails automaticamente. Para forçar uma nova sincronização, edite e salve a série novamente.'
      : 'When you save a series, the backend syncs the Google Drive folder, maps videos into episodes, and tries to populate thumbnails automatically. To force a new sync, edit and save the series again.';
  String get seriesFormTitle => isPtBr ? 'Série' : 'Series';
  String get episodeFormTitle => isPtBr ? 'Episódio' : 'Episode';
  String get registeredSeries => isPtBr ? 'Séries cadastradas' : 'Added series';
  String get saveAndSync =>
      isPtBr ? 'Salvar e sincronizar' : 'Save and sync';
  String get saving => isPtBr ? 'Salvando...' : 'Saving...';
  String get clear => isPtBr ? 'Limpar' : 'Clear';
  String get saveEpisode =>
      isPtBr ? 'Salvar episódio' : 'Save episode';
  String get seriesSaved => isPtBr
      ? 'Série salva. A sincronização da pasta do Drive será executada no backend.'
      : 'Series saved. The Drive folder sync will run on the backend.';
  String saveSeriesError(Object error) =>
      isPtBr ? 'Erro ao salvar série: $error' : 'Failed to save series: $error';
  String get videoSaved => isPtBr
      ? 'Vídeo salvo com sucesso.'
      : 'Video saved successfully.';
  String saveVideoError(Object error) =>
      isPtBr ? 'Erro ao salvar vídeo: $error' : 'Failed to save video: $error';
  String get deleteSeriesTitle =>
      isPtBr ? 'Excluir série' : 'Delete series';
  String deleteSeriesPrompt(String title) => isPtBr
      ? 'Deseja excluir "$title"? Todos os episódios sincronizados dessa série também serão removidos.'
      : 'Do you want to delete "$title"? All synced episodes from this series will also be removed.';
  String get cancel => isPtBr ? 'Cancelar' : 'Cancel';
  String get delete => isPtBr ? 'Excluir' : 'Delete';
  String get seriesDeleted => isPtBr
      ? 'Série excluída com sucesso.'
      : 'Series deleted successfully.';
  String deleteSeriesError(Object error) => isPtBr
      ? 'Erro ao excluir série: $error'
      : 'Failed to delete series: $error';
  String get editSeries => isPtBr ? 'Editar série' : 'Edit series';
  String get deleteSeriesTooltip =>
      isPtBr ? 'Excluir série' : 'Delete series';
  String syncStatus(String status, String error) => isPtBr
      ? 'Status: $status${error.isEmpty ? '' : ' | $error'}'
      : 'Status: $status${error.isEmpty ? '' : ' | $error'}';
  String get noSyncedEpisodes => isPtBr
      ? 'Nenhum episódio sincronizado ainda.'
      : 'No synced episodes yet.';
  String get edit => isPtBr ? 'Editar' : 'Edit';
  String get seriesIdField =>
      isPtBr ? 'ID da série (deixe vazio para criar)' : 'Series ID (leave empty to create)';
  String get seriesTitleField =>
      isPtBr ? 'Título da série' : 'Series title';
  String get seriesDescriptionField =>
      isPtBr ? 'Descrição da série' : 'Series description';
  String get seriesFolderField => isPtBr
      ? 'Link da pasta Google Drive'
      : 'Google Drive folder link';
  String get seriesThumbField => isPtBr
      ? 'Thumbnail da série (opcional; se vazio, tenta usar a primeira thumb sincronizada)'
      : 'Series thumbnail (optional; if empty, tries to use the first synced thumbnail)';
  String get seriesIdRequiredField =>
      isPtBr ? 'ID da série' : 'Series ID';
  String get videoIdField => isPtBr
      ? 'ID do vídeo (preenchido ao editar sincronizado)'
      : 'Video ID (filled when editing a synced item)';
  String get videoTitleField =>
      isPtBr ? 'Título do vídeo' : 'Video title';
  String get videoDescriptionField =>
      isPtBr ? 'Descrição do vídeo' : 'Video description';
  String get videoDriveField => isPtBr
      ? 'Link do arquivo no Google Drive'
      : 'Google Drive file link';
  String get episodeNumberField =>
      isPtBr ? 'Número do episódio' : 'Episode number';
  String get videoThumbField => isPtBr
      ? 'Thumbnail do vídeo (opcional; se vazio, mantém a sincronizada)'
      : 'Video thumbnail (optional; if empty, keeps the synced one)';
  String get requiredField =>
      isPtBr ? 'Campo obrigatório' : 'Required field';
  String get validNumber =>
      isPtBr ? 'Informe um número válido' : 'Enter a valid number';
  String get languageLabel => isPtBr ? 'Idioma' : 'Language';
  String get viewModeLabel => isPtBr ? 'Visualização' : 'View mode';
  String get gridViewLabel => isPtBr ? 'Grade' : 'Grid';
  String get listViewLabel => isPtBr ? 'Lista' : 'List';
  String get portugueseLabel => 'PT-BR';
  String get englishLabel => 'EN';
  String get viewerAccessTitle =>
      isPtBr ? 'Acesso de espectadores' : 'Viewer access';
  String get viewerAccessDescription => isPtBr
      ? 'Se a lista estiver vazia, qualquer usuário autenticado pode acessar o catálogo. Se houver e-mails cadastrados, apenas esses e-mails e o admin terão acesso.'
      : 'If the list is empty, any signed-in user can access the catalog. If there are emails here, only those emails and the admin will have access.';
  String get viewerEmailField =>
      isPtBr ? 'E-mail para liberar acesso' : 'Email to allow access';
  String get addEmail => isPtBr ? 'Adicionar e-mail' : 'Add email';
  String get invalidEmail =>
      isPtBr ? 'Informe um e-mail válido' : 'Enter a valid email';
  String get emailAdded =>
      isPtBr ? 'E-mail adicionado com sucesso.' : 'Email added successfully.';
  String addEmailError(Object error) => isPtBr
      ? 'Erro ao adicionar e-mail: $error'
      : 'Failed to add email: $error';
  String get emailRemoved =>
      isPtBr ? 'E-mail removido com sucesso.' : 'Email removed successfully.';
  String removeEmailError(Object error) => isPtBr
      ? 'Erro ao remover e-mail: $error'
      : 'Failed to remove email: $error';
  String get noViewerRestrictions => isPtBr
      ? 'Nenhum e-mail restrito no momento.'
      : 'No email restrictions configured right now.';
  String get accessDeniedTitle =>
      isPtBr ? 'Acesso não autorizado' : 'Access not authorized';
  String get accessDeniedMessage => isPtBr
      ? 'Sua conta Google não está liberada para assistir a este catálogo.'
      : 'Your Google account is not allowed to watch this catalog.';
  String get backToLogin =>
      isPtBr ? 'Voltar ao login' : 'Back to sign in';
}

extension AppLocalizationContext on BuildContext {
  AppLanguageController get languageController => AppLanguageScope.of(this);

  AppStrings get strings => AppStrings(languageController.language);
}
