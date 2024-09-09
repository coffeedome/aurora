"use client";
import {
  Upload,
  UploadOnAddEvent,
  UploadOnProgressEvent,
  UploadOnStatusChangeEvent,
} from "@progress/kendo-react-upload";
import { useState } from "react";

const UploadResumes = () => {
  const [numResumesThisSession, setNumResumesThisSession] = useState(0);
  const [numResumes, setNumResumes] = useState(0);
  return (
    <div className="m-5">
      <h5>Upload one more more resumes</h5>
      <i>
        * Accepts one or more .zip or .pdf files. ZIP file must contain only
        PDFs
      </i>
      <Upload batch={true} multiple={true} withCredentials={false} />
      <br />
      <div className="d-flex flex-row justify-content-between w-25">
        <div>Number of resumes uploaded on current session: </div>
        <div>{numResumesThisSession}</div>
      </div>
      <br />
      <div className="d-flex flex-row justify-content-between w-25">
        <div>Number of resumes catalogued: </div>
        <div>{numResumes}</div>
      </div>
    </div>
  );
};

export default UploadResumes;
