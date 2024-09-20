"use client";
import {
  AppBar,
  AppBarSection,
  AppBarSpacer,
  Drawer,
  DrawerContent,
} from "@progress/kendo-react-layout";
import UploadResumes from "./components/UploadResumes/UploadResumes";
import SearchForm from "./components/BasicSearch/SearchForm";
import NlpSearch from "./components/NlpSearch";
import { SvgIcon } from "@progress/kendo-react-common";
import { menuIcon } from "@progress/kendo-svg-icons";
import { Button } from "@progress/kendo-react-buttons";
import { useState } from "react";
import Home from "./Home";

export default function RootPage() {
  return <Home></Home>;
}
