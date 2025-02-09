import info from "@/lib/info.json";
import {
	Sidebar,
	SidebarContent,
	SidebarFooter,
	SidebarGroup,
	SidebarGroupContent,
	SidebarHeader,
	SidebarMenu,
	SidebarMenuButton,
	SidebarMenuItem,
} from "@/components/ui/sidebar";

import Link from "next/link";
import {
	BookUser,
	Cog,
	DatabaseZapIcon,
	Hospital,
	PawPrint,
	Stethoscope,
} from "lucide-react";

export function AppSidebar() {
	return (
		<Sidebar>
			<SidebarHeader>
				<SidebarMenu>
					<SidebarMenuItem>
						<SidebarMenuButton size="lg" asChild>
							<Link href="/">
								<div className="flex flex-col gap-0.5 leading-none">
									<span className="font-semibold">Doggos</span>
									<span className="">v{info?.version}</span>
								</div>
							</Link>
						</SidebarMenuButton>
					</SidebarMenuItem>
				</SidebarMenu>
			</SidebarHeader>
			<SidebarContent>
				<SidebarGroup>
					<SidebarGroupContent>
						<SidebarMenu>
							<SidebarMenuItem>
								<Link href="/pets" target="_blank">
									<SidebarMenuButton>
										<PawPrint /> Pet Management
									</SidebarMenuButton>
								</Link>
							</SidebarMenuItem>
							<SidebarMenuItem>
								<Link href="/vets" target="_blank">
									<SidebarMenuButton>
										<Stethoscope />
										<BookUser /> Vets
									</SidebarMenuButton>
								</Link>
							</SidebarMenuItem>

							<SidebarMenuItem>
								<Link href="/emergency-clinics" target="_blank">
									<SidebarMenuButton>
										<Hospital /> Emergency Clinics
									</SidebarMenuButton>
								</Link>
							</SidebarMenuItem>
							<SidebarMenuItem>
								<Link href="/lost-pets" target="_blank">
									<SidebarMenuButton>
										<DatabaseZapIcon /> <PawPrint /> Lost Pet Database
									</SidebarMenuButton>
								</Link>
							</SidebarMenuItem>
							<SidebarMenuItem>
								<Link href="/" target="_blank">
									<SidebarMenuButton>
										<BookUser />
										<PawPrint /> Owners
									</SidebarMenuButton>
								</Link>
							</SidebarMenuItem>
						</SidebarMenu>
					</SidebarGroupContent>
				</SidebarGroup>
			</SidebarContent>
			<SidebarFooter>
				<SidebarMenu>
					<SidebarMenuItem>
						<SidebarMenuButton>
							<Cog /> Settings
						</SidebarMenuButton>
					</SidebarMenuItem>
				</SidebarMenu>
			</SidebarFooter>
		</Sidebar>
	);
}
