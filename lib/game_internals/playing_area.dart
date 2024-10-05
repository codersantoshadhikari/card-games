import 'dart:async';

import 'package:async/async.dart';

import 'playing_card.dart';

class PlayingArea {
  static const int maxCards = 6;

  final List<PlayingCard> cards = [];

  final StreamController<void> _playerChanges =
      StreamController<void>.broadcast();

  final StreamController<void> _remoteChanges =
      StreamController<void>.broadcast();

  PlayingArea();

  Stream<void> get allChanges =>
      StreamGroup.mergeBroadcast([remoteChanges, playerChanges]);

  Stream<void> get playerChanges => _playerChanges.stream;

  Stream<void> get remoteChanges => _remoteChanges.stream;

  void acceptCard(PlayingCard card) {
    cards.add(card);
    _maybeTrim();
    _playerChanges.add(null);
  }

  void dispose() {
    _remoteChanges.close();
    _playerChanges.close();
  }

  void removeFirstCard() {
    if (cards.isEmpty) return;
    cards.removeAt(0);
    _playerChanges.add(null);
  }

  void replaceWith(List<PlayingCard> cards) {
    this.cards.clear();
    this.cards.addAll(cards);
    _maybeTrim();
    _remoteChanges.add(null);
  }

  void _maybeTrim() {
    if (cards.length > maxCards) {
      cards.removeRange(0, cards.length - maxCards);
    }
  }
}
