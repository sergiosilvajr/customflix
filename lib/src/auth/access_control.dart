import 'package:firebase_auth/firebase_auth.dart';

import '../models/access_settings.dart';

const String adminEmail =
    String.fromEnvironment('ADMIN_EMAIL', defaultValue: 'admin@example.com');

bool isAdminUser(User user) {
  final email = user.email?.trim().toLowerCase();
  return user.emailVerified && email == adminEmail;
}

bool hasViewerAccess(User user, AccessSettings settings) {
  if (isAdminUser(user)) {
    return true;
  }

  final email = user.email?.trim().toLowerCase();
  if (email == null || email.isEmpty) {
    return false;
  }

  if (!settings.hasRestrictions) {
    return true;
  }

  return settings.allowedViewerEmails.contains(email);
}
