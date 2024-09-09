"use client";
import { Button } from "@progress/kendo-react-buttons";
import {
  Checkbox,
  InputClearValue,
  InputSeparator,
  TextBox,
  TextBoxChangeEvent,
} from "@progress/kendo-react-inputs";
import { useState } from "react";

const SearchForm = () => {
  const [skills, setSkills] = useState("");
  const handleSkillsFieldChange = (e: TextBoxChangeEvent) => {
    if (e.value) {
      setSkills(e.value.toString());
    }
  };

  return (
    <div className="m-5">
      <h4>Candidate Basic Filter</h4>
      <hr />
      <div>
        <h5>Skills </h5>
        <i>* Comma-separated values</i>
        <br />
        <TextBox
          value={skills}
          onChange={handleSkillsFieldChange}
          className="w-25"
        ></TextBox>
      </div>
      <br />
      <div>
        <h5>Years of Experience</h5>
        <div className="d-flex flex-row m-3 w-50 justify-content-between">
          <Checkbox label={"Less than 1"} className="me-2" />
          <Checkbox label={"1 to 5"} className="me-2" />
          <Checkbox label={"5 to 10"} className="me-2" />
          <Checkbox label={"10+"} className="me-2" />
        </div>
      </div>
      <div>
        <h5>Highest level of education completed</h5>
        <div className="d-flex flex-row m-3 w-75 justify-content-between">
          <Checkbox label={"PhD"} className="me-2" />
          <Checkbox label={"Masters"} className="me-2" />
          <Checkbox label={"Bachelor's Degree"} className="me-2" />
          <Checkbox label={"Associate's Degree"} className="me-2" />
          <Checkbox label={"High School"} className="me-2" />
        </div>
      </div>
      <br />
      <div className="w-25 justify-content-start">
        <Button className="custom-dark-blue-btn">
          <b>Create Analysis</b>
        </Button>
      </div>
    </div>
  );
};

export default SearchForm;
