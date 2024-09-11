"use client";
import {
  AppBar,
  AppBarSection,
  AppBarSpacer,
  Drawer,
  DrawerContent,
} from "@progress/kendo-react-layout";
import UploadResumes from "./components/UploadResumes";
import SearchForm from "./components/BasicSearch/SearchForm";
import NlpSearch from "./components/NlpSearch";
import { SvgIcon } from "@progress/kendo-react-common";
import { menuIcon } from "@progress/kendo-svg-icons";
import { Button } from "@progress/kendo-react-buttons";
import { useState } from "react";
import { StorageBrowser } from "./components/S3FileBrowser";

export default function Home() {
  const [drawerExpanded, setDrawerExpanded] = useState(false);

  const drawerItems = [
    { text: "09/05/2024 - Senior Examiner", icon: "home" },
    { text: "Search", icon: "search" },
    { text: "Upload", icon: "upload" },
  ];
  return (
    <div>
      <AppBar className="custom-appbar align-items-center justify-content-between p-3">
        <AppBarSection className="d-flex align-items-center">
          <Button onClick={() => setDrawerExpanded(!drawerExpanded)}>
            <SvgIcon icon={menuIcon} size="medium" />
          </Button>
        </AppBarSection>
        <AppBarSection className="d-flex align-items-center">
          <h3>
            <b>Aurora Candidate Search Utility</b>
          </h3>
        </AppBarSection>
        <AppBarSection className="d-flex align-items-center">
          <div className="d-flex flex-column">
            <b>Welcome, Esteban</b>
            <b>Sign Out</b>
          </div>
        </AppBarSection>
      </AppBar>
      <div>
        <Drawer
          expanded={drawerExpanded}
          position={"start"}
          width={300}
          mode={"push"}
          items={drawerItems}
          onSelect={() => setDrawerExpanded(!drawerExpanded)}
        >
          <DrawerContent>
            <UploadResumes />
            {/* <StorageBrowser /> */}
            <SearchForm />
            <NlpSearch />
          </DrawerContent>
        </Drawer>
      </div>
    </div>
  );
}
