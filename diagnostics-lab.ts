// Temporary — Effect diagnostic lab. Delete after review.

declare const brand: unique symbol
type Brand<T, B> = T & { readonly [brand]: B }

declare class Effect<out A, out E = never, out R = never> {
  private readonly _A: (_: never) => A
  private readonly _E: (_: never) => E
  private readonly _R: (_: never) => R
}
declare class Layer<out ROut, out E = never, in RIn = never> {
  private readonly _ROut: (_: never) => ROut
  private readonly _E: (_: never) => E
  private readonly _RIn: (_: RIn) => void
}
declare class Scope {
  readonly _tag: 'Scope'
}

declare class Database {
  readonly _tag: 'Database'
}
declare class Http {
  readonly _tag: 'Http'
}
declare class Logger {
  readonly _tag: 'Logger'
}
declare class Config {
  readonly _tag: 'Config'
}

class DbError {
  readonly _tag = 'DbError' as const
}
class NetworkError {
  readonly _tag = 'NetworkError' as const
}
class ConfigError {
  readonly _tag = 'ConfigError' as const
}
class ParseError {
  readonly _tag = 'ParseError' as const
}

type UserId = Brand<string, 'UserId'>
type User = { readonly id: UserId; readonly name: string }

declare function fetchUser(id: UserId): Effect<User, NetworkError | ParseError, Http>
declare function loadConfig(): Effect<{ apiBase: string }, ConfigError, Config>
declare function saveAudit(u: User): Effect<void, DbError, Database | Logger>
declare function openFile(p: string): Effect<string, never, Scope>
declare function andThen<A, B, E1, R1, E2, R2>(
  self: Effect<A, E1, R1>,
  f: (a: A) => Effect<B, E2, R2>
): Effect<B, E1 | E2, R1 | R2>

// ─────────────────────────────────────────────────────────────────────────────
// 1. Missing services (R) — single-channel diff → compact box.
// ─────────────────────────────────────────────────────────────────────────────
function program(id: UserId): Effect<void, NetworkError | ParseError | DbError, never> {
  return andThen(fetchUser(id), u => saveAudit(u))
}

// ─────────────────────────────────────────────────────────────────────────────
// 2. Unhandled errors (E) — single-channel diff → compact box.
// ─────────────────────────────────────────────────────────────────────────────
function totalProgram(id: UserId): Effect<User, never, Http> {
  return fetchUser(id)
}

// ─────────────────────────────────────────────────────────────────────────────
// 3. Wrong success (A) — single-channel diff → compact box.
// ─────────────────────────────────────────────────────────────────────────────
function userName(id: UserId): Effect<string, NetworkError | ParseError, Http> {
  return fetchUser(id)
}

// ─────────────────────────────────────────────────────────────────────────────
// 4. Scope required — Scope leaked into R, expected never → Scope hint.
// ─────────────────────────────────────────────────────────────────────────────
function readFile(p: string): Effect<string, never, never> {
  return openFile(p)
}

// ─────────────────────────────────────────────────────────────────────────────
// 5. Multi-channel: services AND unhandled errors diverge → full view.
// ─────────────────────────────────────────────────────────────────────────────
function composedProgram(id: UserId): Effect<void, never, never> {
  return andThen(
    andThen(fetchUser(id), u => saveAudit(u)),
    () => loadConfig() as unknown as Effect<void, ConfigError, Config>
  )
}

// ─────────────────────────────────────────────────────────────────────────────
// 6. Layer mismatch — got provides Database|Http, expected provides only
//    Database → ROut (covariant) widening error.
// ─────────────────────────────────────────────────────────────────────────────
declare const AppLive: Layer<Database | Http, never, never>
function appLayer(): Layer<Database, never, never> {
  return AppLive
}

export { program, totalProgram, userName, readFile, composedProgram, appLayer }
