import { SiteShell } from "@/components/SiteShell";
import { Hero } from "@/components/hero/Hero";
import { TapAway } from "@/components/sections/TapAway";
import { HowItWorks } from "@/components/sections/HowItWorks";
import { Features } from "@/components/sections/Features";
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
      <TapAway />
      <HowItWorks />
      <Features />
      <Fares />
      <Coverage />
      <Safety />
      <Wallet />
      <Faq />
      <Download />
    </SiteShell>
  );
}
