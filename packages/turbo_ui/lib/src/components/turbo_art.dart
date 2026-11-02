import 'package:flutter/widgets.dart';

/// The 3D pictures from the design kit (`assets/icons3d`). Each one is a transparent PNG with its own light and shadow,
/// so it needs no tint. They are decoration: hidden from screen readers, so the words beside them carry the meaning.
enum TurboArt {
  alarmClock('alarm-clock'),
  automobile('automobile'),
  bell('bell'),
  books('books'),
  bustsInSilhouette('busts-in-silhouette'),
  calendar('calendar'),
  camera('camera'),
  checkMarkButton('check-mark-button'),
  coin('coin'),
  creditCard('credit-card'),
  graduationCap('graduation-cap'),
  hourglassNotDone('hourglass-not-done'),
  house('house'),
  identificationCard('identification-card'),
  key('key'),
  locked('locked'),
  mobilePhone('mobile-phone'),
  moneyBag('money-bag'),
  motorway('motorway'),
  oncomingTaxi('oncoming-taxi'),
  partyPopper('party-popper'),
  roundPushpin('round-pushpin'),
  school('school'),
  shield('shield'),
  speechBalloon('speech-balloon'),
  telephoneReceiver('telephone-receiver'),
  warning('warning'),
  wrench('wrench');

  const TurboArt(this.file);

  final String file;

  ImageProvider get image =>
      AssetImage('assets/icons3d/i3d-$file.png', package: 'turbo_ui');
}

/// A [TurboArt] picture at a given size, hidden from screen readers.
class TurboArtImage extends StatelessWidget {
  const TurboArtImage(this.art, {super.key, this.size = 44});

  final TurboArt art;
  final double size;

  @override
  Widget build(BuildContext context) => ExcludeSemantics(
    child: Image(
      image: art.image,
      width: size,
      height: size,
      fit: BoxFit.contain,
    ),
  );
}
