import { SiteShell } from "@/components/SiteShell";
import { Hero } from "@/components/hero/Hero";
import { HowItWorks } from "@/components/sections/HowItWorks";
import { Fares } from "@/components/sections/Fares";
import { Coverage } from "@/components/sections/Coverage";
import { Safety } from "@/components/sections/Safety";
import { Wallet } from "@/components/sections/Wallet";
import { Faq } from "@/components/sections/Faq";
import { Download } from "@/components/sections/Download";

export default function Home() {
  return (
    <SiteShell>
      <Hero />
      <HowItWorks />
      <Fares />
      <Coverage />
      <Safety />
      <Wallet />
      <Faq />
      <Download />
    </SiteShell>
  );
}
