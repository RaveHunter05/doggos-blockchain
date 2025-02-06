"use client";

import { PrivyProvider } from "@privy-io/react-auth";

export default function CustomPrivyProvider({
  children,
}: Readonly<{ children: React.ReactNode }>) {
  return (
    <PrivyProvider
      appId="cm6rhzm3703nxl4bz4nn0z6n5"
      config={{
        embeddedWallets: {
          createOnLogin: "all-users",
        },
      }}
    >
      {children}
    </PrivyProvider>
  );
}
