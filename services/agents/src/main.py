import boto3
from langchain_aws import ChatBedrock
from crewai import Agent, Process, Task, Crew

# Set up Amazon Bedrock Boto3 client
bedrock_runtime = boto3.client(service_name="bedrock-runtime", region_name="us-west-2")

# Configure the model to use
model_id = "anthropic.claude-3-haiku-20240307-v1:0"
model_kwargs = {
    "max_tokens": 2048,
    "temperature": 0.1,
    "top_k": 250,
    "top_p": 1,
    "stop_sequences": ["\n\nHuman"],
}

# Create the LangChain Chat object
llm = ChatBedrock(
    client=bedrock_runtime,
    model_id=model_id,
    model_kwargs=model_kwargs,
)

# We define our agents:
job_candidate_match_analyst = Agent(
    role="Job-to-Candidate Match Analyst",
    goal="""Provide a list of job candidates sorted by overall
    percentage match and then by skills percentage match, years of experience match, 
    and education degree""",
    backstory="""You are highly skilled Job Candidate Match Analyst,
    known for your ability to review hundreds of job applicant's resumes,
    finding close matches and producing reports for other people to easily review""",
    verbose=True,
    allow_delegation=True,
    llm=llm,
)

# Now we give tasks to our agents
task1 = Task(
    description="""Conduct a comprehensive review of the list of PDF resumes provided
  and use provided search criteria to generate a percent match report""",
    expected_output="""JSON payload with list of candidates exceeding 90 percent overall
    match. The payload must include in the following order the following fields:
    Overall Percent Match, Full name, Current Job Role, Experience Percent Match, 
    Years of Experience, Top Skills Percent Match,
    Top 5 Skills, Educational Degree Percent Match, Educational Degree""",
    agent=job_candidate_match_analyst,
)

# Instantiate your crew with a sequential process
crew = Crew(
    agents=[job_candidate_match_analyst],
    tasks=[task1],
    verbose=True,
    process=Process.sequential,
)

# Get your crew to work!
result = crew.kickoff()

print("######################")
print(result)


# PDFSearchTool for getting files:
# https://docs.crewai.com/tools/PDFSearchTool/#example
