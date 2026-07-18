# Phase 3: Animation framework

## Client exports

- `exports.cinedirector:PlayAnimation(ped, animation[, options])` plays a registry key or `{ dictionary, clip }` descriptor on a ped. `options` supports `loop`, `blendIn`, `blendOut`, `speed`, and `duration`.
- `exports.cinedirector:StopAnimation(ped)` stops only the animation started by this framework for that ped.
- `exports.cinedirector:PreviewAnimation(animation[, options])` previews on the director's player ped and records a history item server-side.
- `exports.cinedirector:SearchAnimations(query[, options])` returns instant local results. `options.category` and `options.tag` narrow results.
- `exports.cinedirector:AddFavoriteAnimation(key)` and `RemoveFavoriteAnimation(key)` persist a registry entry for the active player.

## Server callbacks

- `GetFavorites` returns the caller's `director_animation_favorites` rows.
- `SaveFavorite` accepts `{ dictionary, animation }`, validates both fields, enforces `Config.Animation.favoriteLimit`, and inserts idempotently.
- `DeleteFavorite` removes the caller's matching favorite.

## Events

`cinedirector:animation:history` is client-to-server and stores an authenticated player's preview history. It validates dictionary and animation length. Do not invoke it from untrusted browser code.

## Lifecycle and performance

`AnimationCache.Acquire` requests each dictionary on demand. The cache is reference counted; release occurs when a managed preview stops. A 30-second maintenance interval only prunes unused assets that have exceeded `Config.Animation.unusedAssetSeconds`; it performs no native work while idle. Run `sql/002_animation_framework.sql` after the existing migrations.
