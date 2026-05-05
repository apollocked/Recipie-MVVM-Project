import 'package:dio_receipe/core/routes/app_route_constants.dart';
import 'package:dio_receipe/global.dart';
import 'package:dio_receipe/views/Pages/home_screen.dart';
import 'package:dio_receipe/views/Pages/liked_pages.dart';
import 'package:dio_receipe/views/layout/layout_page.dart';
import 'package:go_router/go_router.dart';

class MyAppRouter {
  MyAppRouter();

  static GoRouter returnRouter(Global global) {
    return GoRouter(
      debugLogDiagnostics: true,

      initialLocation: '/',
      routes: [
        StatefulShellRoute.indexedStack(
          builder: (context, state, navigationShell) {
            return MyScaffoldWithNavBar(navigationShell: navigationShell);
          },
          branches: [
            // BRANCH 1: HOME (and its sub-pages)
            StatefulShellBranch(
              routes: [
                GoRoute(
                  name: MyAppRouteConstants.home,
                  path: '/',
                  builder: (context, state) =>
                      HomeScreen(flavorName: global.flavorName),
                ),
              ],
            ),

            // BRANCH 2: PROFILE
            StatefulShellBranch(
              routes: [
                GoRoute(
                  name: MyAppRouteConstants.favs,
                  path: '/favs',
                  builder: (context, state) => LikedReciepesPage(),
                ),
              ],
            ),

            // BRANCH 3: SETTINGS
            StatefulShellBranch(
              routes: [
                GoRoute(
                  name: MyAppRouteConstants.settings,
                  path: '/settings',
                  builder: (context, state) => const LikedReciepesPage(),
                ),
              ],
            ),
          ],
        ),
        GoRoute(
          name: MyAppRouteConstants.details,
          path: '/details',
          builder: (context, state) => const LikedReciepesPage(),
        ),
      ],
      redirect: (context, state) {
        return null;

        // // Use state.uri.path to get the actual URL path
        // final goingToProfile = state.uri.path.startsWith('/profile');

        // if (!loggedIn && goingToProfile) {
        //   return '/contact-us'; // Redirect to the contact us page (its login and register page)
        // }
        // return null; // Allow navigation
      },
      // errorBuilder: (context, state) => const MyErrorPage(),
    );
  }
}
