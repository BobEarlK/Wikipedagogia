//
//  Playground.swift
//  Wikipedagogia
//
//  Created by BobEarl on 3/16/26.
//

import Playgrounds
import FoundationModels

// UserTopic maps a wikipedia topic to a given user, with an affinity and mastery Bayesian score.  A single session will involve generated questions and subsequent answers from the user.  After each user input, the model will attempt to name the specific wikipedia topic that is being addressed and to infer a degree of mastery and interest/affinity.  It will ask a question that attempts to probe the knowledge and interest of the user, and at the same time to direct the user toward areas where the user has interest but not mastery. Based on the answer to the question, the session will ask another question.  In order to track growth, it makes sense for a topic snapshot to have a user, a Bayesian affinity, a Bayesian mastery, and a history of questions and answers on that topic and their effects on those score
@Generable
struct Exchange {
    @Guide(description: "A question put to the user") var question: String
    @Guide(description: "The user answer")
    var answer: String
    @Guide(description: "An array of TopicScores that are related to the question and the answer with the change in the scores suggested by the question and answer") var scoreChanges: [TopicScore]
}
@Generable
struct UserTopic {
    var topicScore: TopicScore
    var user: String
}
@Generable
struct TopicScore {
    @Guide(description: "A topic") var topic: String
    @Guide(description: "Bayesian score between 0 and 1 that describes the level of mastery of a topic.  A mastery of 0 means no familiarity with the subject at all, a level of 1 means expertise at the level of someone who could teach or present on the topic.  Some possible interval levels:  0.1, know of the topic; 0.2, understand the meaning of the topic and be aware of what general topics it is related to.  0.4, be able to recall some specifics with prompting about the topic; 0.6 be able to broadly discuss a topic without prompting; 0.8 be able to discuss a topic in detail and with nuance") var mastery: Double
    @Guide(description: "Bayesian score between 0 and 1 that describes the level of affinity or interest for a topic.  0:  no interest at all; 1: fascination and awe; 0.8 deep curiosity; 0.3 moderate interest") var affinity: Double
}

#Playground {
    let instructions = Instructions {
        "You are mapping a user's interest and knowledge across a broad swath of topics in order to gamify a user's pursuit of knowledge.  Your goal is to create a session based on a user's question and knowledge of the user's prior knowledge and interests.  A session starts with a question usually starting with something like, is there anything in particular you'd like to explore?  You will engage in an exchange with the user, where you will impute a level of interest and mastery of a topic based on the user's input, and generate a question that tests the user's knowledge."
        "As a general rule, you will try to limit a session to 10 questions unless the user specifies otherwise.  You are trying to focus on depth of understanding and ability to connect events or concepts.  For example, it is important to you that the assassination of Archduke Ferdinand precipitated World War I, and that World War I coincided with the Spanish Flu and preceded the roaring 20's, but you are not fussy about the exact date or city where the assassination happened."
        "At the end of the session, you will attempt to summarize the most sizable changes in a TopicScore to give the user information about what topics they showed mastery over or not, and which ones they showed interest in or not, and suggest some topics for remediation or extension.  You will then update the user's scores across all of the user's topics at the end of the session to help predict how they might approach topics going forward"
        
    }
    let session = LanguageModelSession(instructions: instructions)
    let prompt = "Assume that a user just answered a question about string theory confidently, but was uncertain about quantum mechanics.  You are able to realize that these two topics are somewhat closely related, and that users expert in one are likely to be at least quite familiar with the other; users who are ignorant of one often will not be expert at the otehr, and with interest in one often but not always have interest in the other.  Generate a topic score for each"
    let response = try await session.respond(to: prompt, generating: [Exchange].self )
    print(response.content)
}
