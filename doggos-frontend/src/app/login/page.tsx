"use client";

import Portal from "@/components/graphics/portal";
import { PrivyClient, useLogin } from "@privy-io/react-auth";

import { GetServerSideProps } from "next";
import Head from "next/head";
import Image from "next/image";
import { useRouter } from "next/navigation";

export default function LoginPage() {
  const router = useRouter();
  const { login } = useLogin({
    onComplete: () => router.push("/dashboard"),
  });

  return (
    <>
      <Head>
        <title>Login · Privy</title>
      </Head>

      <main className="flex min-h-screen min-w-full">
        <div className="flex bg-privy-light-blue flex-1 p-6 justify-center items-center">
          <div>
            <div>
              <Image
                src="/doggos.webp"
                alt="Privy Logo"
                width={200}
                height={200}
		className="rounded-full"
              />
            </div>
            <div className="mt-6 flex justify-center text-center">
              <button
                className="bg-amber-500 hover:bg-amber-600 text-white font-bold py-2 px-4 rounded"
                onClick={login}
              >
                Log in
              </button>
            </div>
          </div>
        </div>
      </main>
    </>
  );
}
