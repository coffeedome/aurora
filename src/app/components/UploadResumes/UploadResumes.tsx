"use client";
import {
  Upload,
  UploadFileInfo,
  UploadOnAddEvent,
  UploadOnProgressEvent,
  UploadOnStatusChangeEvent,
} from "@progress/kendo-react-upload";
import { useState } from "react";

const UploadResumes = () => {
  const [numResumesThisSession, setNumResumesThisSession] = useState(0);
  const [numResumes, setNumResumes] = useState(0);

  //const RESUMES_APIGW_ENDPOINT = process.env.RESUMES_APIGW_ENDPOINT;
  const RESUMES_APIGW_ENDPOINT =
    "https://kbsbpn7tc4.execute-api.us-west-2.amazonaws.com";
  if (!RESUMES_APIGW_ENDPOINT) {
    throw new Error("RESUMES_APIGW_ENDPOINT is undefined");
  }

  const handleFileUpload = async (event: UploadOnAddEvent) => {
    const files = event.newState;

    if (files.length > 0) {
      const fileInfo: UploadFileInfo = files[0]; // Assuming single file upload

      const reader = new FileReader();

      // Read the file as base64
      reader.onload = async (e) => {
        const file = fileInfo.getRawFile ? fileInfo.getRawFile() : undefined; // Extract the raw file object
        if (e.target && file) {
          const result = e.target.result as string; // Type assertion
          const base64File = result.split(",")[1]; // Get base64 part
          const fileName = file;

          // Prepare the request body
          const body = JSON.stringify({
            file_content: base64File,
            file_name: fileName,
          });

          try {
            const response = await fetch(
              RESUMES_APIGW_ENDPOINT + "/resumes/upload",
              {
                method: "POST",
                headers: {
                  "Content-Type": "application/json",
                },
                body: body,
              }
            );

            if (response.ok) {
              const result = await response.json();
              console.log("Upload successful:", result);
            } else {
              console.error("Upload failed:", response.statusText);
            }
          } catch (error) {
            console.error("Error uploading file:", error);
          }
        }

        // Convert file to base64
        if (file) {
          reader.readAsDataURL(file);
        }
      };
    }
  };

  return (
    <div className="m-5">
      <h5>Upload one more more resumes</h5>
      <i>
        * Accepts one or more .zip or .pdf files. ZIP file must contain only
        PDFs
      </i>
      <Upload
        batch={true}
        multiple={true}
        withCredentials={false}
        onAdd={handleFileUpload}
      />
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
