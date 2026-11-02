import { Header } from "./Header";
import { Footer } from "./Footer";
import { Motion } from "./Motion";

export function SiteShell({ children }: { children: React.ReactNode }) {
  return (
    <>
      <Header />
      <main id="main" tabIndex={-1} className="relative isolate outline-none">
        {children}
      </main>
      <Footer />
      <Motion />
    </>
  );
}
