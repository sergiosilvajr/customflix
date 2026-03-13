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
  String get seriesTitle => isPtBr ? 'Series' : 'Series';
  String get searchSeriesHint => isPtBr
      ? 'Buscar serie por titulo ou descricao'
      : 'Search series by title or description';
  String get noSeriesYet =>
      isPtBr ? 'Nenhuma serie cadastrada ainda.' : 'No series added yet.';
  String noSeriesFound(String query) => isPtBr
      ? 'Nenhuma serie encontrada para "$query".'
      : 'No series found for "$query".';
  String get signInIntro => isPtBr
      ? 'Entre com sua conta Google para assistir. A area administrativa e restrita ao email autorizado.'
      : 'Sign in with your Google account to watch. The admin area is restricted to the authorized email.';
  String get signInWithGoogle =>
      isPtBr ? 'Entrar com Google' : 'Continue with Google';
  String get signingIn => isPtBr ? 'Entrando...' : 'Signing in...';
  String signInError(Object error) =>
      isPtBr ? 'Falha no login Google: $error' : 'Google sign-in failed: $error';
  String get episodes => isPtBr ? 'Episodios' : 'Episodes';
  String get noVideosInSeries => isPtBr
      ? 'Sem videos cadastrados para esta serie.'
      : 'No videos have been added to this series yet.';
  String get noDescription =>
      isPtBr ? 'Sem descricao.' : 'No description.';
  String get originalLinkLabel =>
      isPtBr ? 'Link original' : 'Original link';
  String get driveFolderLabel =>
      isPtBr ? 'Pasta Drive' : 'Drive folder';
  String get playerOnlyWeb => isPtBr
      ? 'Player de video disponivel apenas no Flutter Web.'
      : 'Video player is only available on Flutter Web.';
  String get adminCatalogTitle =>
      isPtBr ? 'Admin - Catalogo' : 'Admin - Catalog';
  String get restrictedAdminAccess => isPtBr
      ? 'Acesso restrito ao administrador.'
      : 'Access restricted to the administrator.';
  String get syncInfo => isPtBr
      ? 'Ao salvar uma serie, o backend sincroniza a pasta do Google Drive, mapeia os videos em episodios e tenta preencher thumbnails automaticamente. Para forcar nova sincronizacao, edite e salve a serie novamente.'
      : 'When you save a series, the backend syncs the Google Drive folder, maps videos into episodes, and tries to populate thumbnails automatically. To force a new sync, edit and save the series again.';
  String get seriesFormTitle => isPtBr ? 'Serie' : 'Series';
  String get episodeFormTitle => isPtBr ? 'Episodio' : 'Episode';
  String get registeredSeries => isPtBr ? 'Series cadastradas' : 'Added series';
  String get saveAndSync =>
      isPtBr ? 'Salvar e sincronizar' : 'Save and sync';
  String get saving => isPtBr ? 'Salvando...' : 'Saving...';
  String get clear => isPtBr ? 'Limpar' : 'Clear';
  String get saveEpisode =>
      isPtBr ? 'Salvar episodio' : 'Save episode';
  String get seriesSaved => isPtBr
      ? 'Serie salva. A sincronizacao da pasta do Drive sera executada no backend.'
      : 'Series saved. The Drive folder sync will run on the backend.';
  String saveSeriesError(Object error) =>
      isPtBr ? 'Erro ao salvar serie: $error' : 'Failed to save series: $error';
  String get videoSaved => isPtBr
      ? 'Video salvo com sucesso.'
      : 'Video saved successfully.';
  String saveVideoError(Object error) =>
      isPtBr ? 'Erro ao salvar video: $error' : 'Failed to save video: $error';
  String get deleteSeriesTitle =>
      isPtBr ? 'Excluir serie' : 'Delete series';
  String deleteSeriesPrompt(String title) => isPtBr
      ? 'Deseja excluir "$title"? Todos os episodios sincronizados dessa serie tambem serao removidos.'
      : 'Do you want to delete "$title"? All synced episodes from this series will also be removed.';
  String get cancel => isPtBr ? 'Cancelar' : 'Cancel';
  String get delete => isPtBr ? 'Excluir' : 'Delete';
  String get seriesDeleted => isPtBr
      ? 'Serie excluida com sucesso.'
      : 'Series deleted successfully.';
  String deleteSeriesError(Object error) => isPtBr
      ? 'Erro ao excluir serie: $error'
      : 'Failed to delete series: $error';
  String get editSeries => isPtBr ? 'Editar serie' : 'Edit series';
  String get deleteSeriesTooltip =>
      isPtBr ? 'Excluir serie' : 'Delete series';
  String syncStatus(String status, String error) => isPtBr
      ? 'Status: $status${error.isEmpty ? '' : ' | $error'}'
      : 'Status: $status${error.isEmpty ? '' : ' | $error'}';
  String get noSyncedEpisodes => isPtBr
      ? 'Nenhum episodio sincronizado ainda.'
      : 'No synced episodes yet.';
  String get edit => isPtBr ? 'Editar' : 'Edit';
  String get seriesIdField =>
      isPtBr ? 'ID da serie (deixe vazio para criar)' : 'Series ID (leave empty to create)';
  String get seriesTitleField =>
      isPtBr ? 'Titulo da serie' : 'Series title';
  String get seriesDescriptionField =>
      isPtBr ? 'Descricao da serie' : 'Series description';
  String get seriesFolderField => isPtBr
      ? 'Link da pasta Google Drive'
      : 'Google Drive folder link';
  String get seriesThumbField => isPtBr
      ? 'Thumbnail da serie (opcional; se vazio, tenta usar a primeira thumb sincronizada)'
      : 'Series thumbnail (optional; if empty, tries to use the first synced thumbnail)';
  String get seriesIdRequiredField =>
      isPtBr ? 'ID da serie' : 'Series ID';
  String get videoIdField => isPtBr
      ? 'ID do video (preenchido ao editar sincronizado)'
      : 'Video ID (filled when editing a synced item)';
  String get videoTitleField =>
      isPtBr ? 'Titulo do video' : 'Video title';
  String get videoDescriptionField =>
      isPtBr ? 'Descricao do video' : 'Video description';
  String get videoDriveField => isPtBr
      ? 'Link do arquivo no Google Drive'
      : 'Google Drive file link';
  String get episodeNumberField =>
      isPtBr ? 'Numero do episodio' : 'Episode number';
  String get videoThumbField => isPtBr
      ? 'Thumbnail do video (opcional; se vazio, mantem a sincronizada)'
      : 'Video thumbnail (optional; if empty, keeps the synced one)';
  String get requiredField =>
      isPtBr ? 'Campo obrigatorio' : 'Required field';
  String get validNumber =>
      isPtBr ? 'Informe um numero valido' : 'Enter a valid number';
  String get languageLabel => isPtBr ? 'Idioma' : 'Language';
  String get portugueseLabel => 'PT-BR';
  String get englishLabel => 'EN';
  String get viewerAccessTitle =>
      isPtBr ? 'Acesso de espectadores' : 'Viewer access';
  String get viewerAccessDescription => isPtBr
      ? 'Se a lista estiver vazia, qualquer usuario autenticado pode acessar o catalogo. Se houver emails cadastrados, apenas esses emails e o admin terao acesso.'
      : 'If the list is empty, any signed-in user can access the catalog. If there are emails here, only those emails and the admin will have access.';
  String get viewerEmailField =>
      isPtBr ? 'Email para liberar acesso' : 'Email to allow access';
  String get addEmail => isPtBr ? 'Adicionar email' : 'Add email';
  String get invalidEmail =>
      isPtBr ? 'Informe um email valido' : 'Enter a valid email';
  String get emailAdded =>
      isPtBr ? 'Email adicionado com sucesso.' : 'Email added successfully.';
  String addEmailError(Object error) => isPtBr
      ? 'Erro ao adicionar email: $error'
      : 'Failed to add email: $error';
  String get emailRemoved =>
      isPtBr ? 'Email removido com sucesso.' : 'Email removed successfully.';
  String removeEmailError(Object error) => isPtBr
      ? 'Erro ao remover email: $error'
      : 'Failed to remove email: $error';
  String get noViewerRestrictions => isPtBr
      ? 'Nenhum email restrito no momento.'
      : 'No email restrictions configured right now.';
  String get accessDeniedTitle =>
      isPtBr ? 'Acesso nao autorizado' : 'Access not authorized';
  String get accessDeniedMessage => isPtBr
      ? 'Sua conta Google nao esta liberada para assistir este catalogo.'
      : 'Your Google account is not allowed to watch this catalog.';
  String get backToLogin =>
      isPtBr ? 'Voltar ao login' : 'Back to sign in';
}

extension AppLocalizationContext on BuildContext {
  AppLanguageController get languageController => AppLanguageScope.of(this);

  AppStrings get strings => AppStrings(languageController.language);
}
