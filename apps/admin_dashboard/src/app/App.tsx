import { appEnv, showEnvBadge } from './env';
import { strings } from './strings';
import styles from './App.module.css';

/** App shell: top bar with wordmark and environment badge. Screens arrive in later tasks. */
export function App() {
  return (
    <div className={styles.shell}>
      <header className={styles.topBar}>
        <span className={styles.wordmark}>{strings.appName}</span>
        {showEnvBadge && (
          <span className={styles.badge} aria-label={strings.environment(appEnv)}>
            {appEnv}
          </span>
        )}
      </header>
      <main className={styles.main}>
        <section className={styles.card} aria-labelledby="signed-out-title">
          <h1 id="signed-out-title" className={styles.title}>
            {strings.signedOutTitle}
          </h1>
          <p className={styles.body}>{strings.signedOutBody}</p>
        </section>
      </main>
    </div>
  );
}
