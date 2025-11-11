# Team Management Guide

Comprehensive guide for managing and developing the Solution Architecture team, including hiring, performance management, career development, and team culture.

## 📋 Table of Contents

- [Team Structure](#team-structure)
- [Hiring & Recruitment](#hiring--recruitment)
- [Onboarding](#onboarding)
- [Performance Management](#performance-management)
- [Career Development](#career-development)
- [Team Culture](#team-culture)
- [Workload Management](#workload-management)
- [Retention Strategies](#retention-strategies)

## 🏗️ Team Structure

### Recommended Team Composition

**For Organizations with 100-300 Engineers:**

```
Director of Architecture (1)
├── Principal Solution Architect (1)
├── Principal Security Architect (1)
├── Principal Data Architect (1)
├── Senior Solution Architects (3-4)
└── Solution Architects (2-3)

Total: 9-11 architects
Ratio: 1 architect per 10-30 engineers
```

**For Larger Organizations (300+ Engineers):**

```
Director of Architecture (1)
├── Principal Architects (4-5)
│   ├── Application Architecture
│   ├── Data & Integration
│   ├── Cloud & Infrastructure
│   ├── Security Architecture
│   └── Enterprise Architecture
│
├── Senior Solution Architects (6-8)
│   └── Aligned to business domains or product areas
│
└── Solution Architects (8-12)
    └── Embedded with delivery teams

Total: 19-26 architects
Ratio: 1 architect per 15-20 engineers
```

### Role Definitions

#### Director of Architecture (Practice Lead)
- **Level:** Senior Leadership (Director/VP)
- **Reports to:** CTO or VP Engineering
- **Team Size:** 8-25 direct reports
- **Responsibilities:** Practice strategy, team leadership, governance, executive partnership
- **Experience:** 15+ years, 5+ in leadership

#### Principal Architect
- **Level:** Individual Contributor or Manager
- **Reports to:** Director of Architecture
- **Team Size:** 0-5 (if manager)
- **Responsibilities:** Domain expertise, technical leadership, standard setting, mentorship
- **Experience:** 12+ years, deep expertise in domain

#### Senior Solution Architect
- **Level:** Senior Individual Contributor
- **Reports to:** Director or Principal Architect
- **Team Size:** 0
- **Responsibilities:** Complex solution design, ARB participation, technical mentorship
- **Experience:** 8-12 years, broad and deep technical skills

#### Solution Architect
- **Level:** Mid-level Individual Contributor
- **Reports to:** Director or Principal Architect
- **Team Size:** 0
- **Responsibilities:** Solution design, architecture documentation, team support
- **Experience:** 5-8 years, solid technical foundation

#### Associate/Junior Architect
- **Level:** Early Career
- **Reports to:** Senior or Principal Architect
- **Team Size:** 0
- **Responsibilities:** Architecture support, documentation, learning and growth
- **Experience:** 3-5 years development + architecture interest

### Team Operating Models

#### Model 1: Centralized Team
- All architects report to Practice Lead
- Assigned to projects on rotation
- **Pros:** Consistency, knowledge sharing, career development
- **Cons:** Potential disconnect from delivery teams

#### Model 2: Embedded Model
- Architects embedded in product/engineering teams
- Dotted-line to Practice Lead
- **Pros:** Deep context, delivery focus, team integration
- **Cons:** Risk of silos, harder to maintain standards

#### Model 3: Hybrid Model (Recommended)
- Principal/Senior architects centralized
- Some architects embedded, others rotating
- Strong community of practice
- **Pros:** Balance of consistency and context
- **Cons:** Requires strong coordination

## 🎯 Hiring & Recruitment

### Hiring Strategy

#### Workforce Planning
- **Annual Planning:** Align headcount to business growth and project pipeline
- **Skills Gap Analysis:** Identify critical skills gaps quarterly
- **Build vs. Buy:** Balance hiring for immediate needs vs. developing talent
- **Diversity Goals:** Set targets for diverse candidate slate and hiring

#### Recruitment Channels
1. **Employee Referrals** - Best quality and cultural fit
2. **LinkedIn Recruiting** - Active sourcing for senior roles
3. **Job Boards** - Indeed, Glassdoor for broad reach
4. **Conferences & Meetups** - Build relationships with community
5. **University Programs** - Early career pipeline
6. **Recruiting Agencies** - Hard-to-fill or executive roles

### Job Descriptions

#### Key Components
- **Role Summary:** Clear description of role and impact
- **Responsibilities:** Specific duties and expectations
- **Required Qualifications:** Must-have skills and experience
- **Preferred Qualifications:** Nice-to-have differentiators
- **Technologies:** Relevant tech stack
- **What We Offer:** Value proposition (culture, growth, impact)

#### Example: Solution Architect Job Description

```markdown
## Solution Architect

### About the Role
We're looking for a Solution Architect to design and guide the implementation 
of complex, scalable solutions that drive business value. You'll work closely 
with engineering teams, product managers, and stakeholders to translate 
business requirements into robust technical architectures.

### What You'll Do
- Design end-to-end solution architectures for strategic initiatives
- Create architecture documentation, diagrams, and decision records
- Guide development teams through implementation
- Participate in Architecture Review Board
- Contribute to architecture standards and patterns
- Mentor engineers on architecture and design best practices

### What We're Looking For
**Required:**
- 5+ years of software development experience
- 2+ years designing distributed systems and cloud architectures
- Strong knowledge of AWS or Azure
- Experience with microservices, APIs, and event-driven architectures
- Proficiency in at least one language (Java, Python, Node.js, etc.)
- Excellent communication and documentation skills

**Preferred:**
- Cloud certifications (AWS Solutions Architect, Azure Architect)
- Experience with Kubernetes and containerization
- Knowledge of domain-driven design and architecture patterns
- Track record of leading technical initiatives
- Experience with architecture frameworks (TOGAF, C4)

### Technologies We Use
AWS, Kubernetes, Python, Java, Node.js, React, PostgreSQL, MongoDB, 
Kafka, Redis, Terraform, GitHub, DataDog

### What We Offer
- High-impact work on strategic initiatives
- Collaborative, learning-focused culture
- Investment in your professional development
- Competitive compensation and benefits
- Remote-friendly workplace
```

### Interview Process

#### Standard Architecture Interview Loop

**Stage 1: Recruiter Screen (30 min)**
- Assess basic fit and interest
- Explain role and company
- Discuss compensation expectations
- Qualify experience level

**Stage 2: Hiring Manager Screen (45-60 min)**
- Deep dive on background and experience
- Discuss architecture approach and philosophy
- Assess communication skills
- Evaluate cultural fit
- Answer candidate questions

**Stage 3: Technical Assessment (60-90 min)**

Option A: System Design Interview
- Present business problem
- Candidate designs solution on whiteboard/virtual board
- Assess requirements gathering, design thinking, trade-off analysis
- Deep dive on specific areas (data, security, scalability)

Option B: Architecture Review
- Candidate presents past project architecture (prepare ahead)
- Panel asks questions and probes decisions
- Assess depth, decision-making, and learning from outcomes

**Stage 4: Panel Interviews (2-3 hours)**

- **Architecture Deep Dive (60 min)** - Principal Architect
  - Advanced technical scenarios
  - Architecture patterns and principles
  - Technology breadth and depth

- **Collaboration & Communication (45 min)** - Engineering Manager
  - Stakeholder management scenarios
  - Conflict resolution
  - Influence without authority

- **Leadership & Culture (45 min)** - Practice Lead
  - Strategic thinking
  - Mentorship and team development
  - Values alignment

**Stage 5: Executive Interview (30-45 min)** - For Senior+ roles
- Meet with CTO or VP Engineering
- Discuss vision and strategy
- Assess executive presence
- Final culture fit validation

**Stage 6: Reference Checks**
- 2-3 professional references
- Focus on architecture work and collaboration

#### Evaluation Criteria

Score each area 1-5:

| Criteria | Weight | Description |
|----------|--------|-------------|
| Technical Depth | 25% | Deep expertise in relevant domains |
| Architecture Skills | 25% | System design, patterns, trade-offs |
| Communication | 15% | Clear, effective communicator |
| Collaboration | 15% | Works well with diverse teams |
| Strategic Thinking | 10% | Sees big picture, balances concerns |
| Cultural Fit | 10% | Alignment with values and culture |

**Decision Matrix:**
- **Strong Hire:** 4.0+ average, no area < 3.0
- **Hire:** 3.5+ average, no area < 2.5
- **No Hire:** < 3.5 average or any area < 2.5

### Offer & Closing

**Compensation Components:**
- Base salary (market competitive)
- Annual bonus (typically 10-20%)
- Equity/RSUs (if applicable)
- Benefits package
- Professional development budget

**Tips for Closing Candidates:**
- Move quickly - make offer within 48 hours of final interview
- Personalize offer presentation - highlight what they'll work on
- Involve team - have future colleagues reach out
- Be flexible - negotiate where possible
- Stay engaged - check in during notice period

## 🚀 Onboarding

See [New Architect Onboarding Plan](../training/onboarding/new-architect-onboarding.md) for complete 90-day program.

### First Week Essentials

**Day 1:**
- Workspace setup (laptop, accounts, tools)
- Team introduction and welcome
- 1:1 with manager
- Assign onboarding buddy
- Review onboarding plan

**Week 1:**
- Complete IT and security training
- Access all relevant systems
- Read architecture documentation
- Attend team meetings as observer
- Meet key stakeholders

### 30-60-90 Day Goals

**30 Days:**
- Understand practice mission, principles, and processes
- Complete onboarding training modules
- Shadow architecture reviews
- Contribute to low-risk architecture documentation

**60 Days:**
- Lead first architecture review with support
- Contribute to ADR or standard
- Begin first project engagement
- Present learning to team

**90 Days:**
- Independently lead architecture for project
- Demonstrate competency in core skills
- Build relationships with key stakeholders
- Provide feedback on onboarding process

## 📊 Performance Management

### Performance Framework

#### Continuous Performance Management

**Weekly 1:1s (30-60 min)**
- Check-in on current work and blockers
- Discuss challenges and support needed
- Provide coaching and feedback
- Build relationship and trust

**Monthly Reviews**
- Review progress on goals and projects
- Discuss career development
- Address any performance concerns early
- Recognize achievements

**Quarterly Performance Reviews**
- Formal performance assessment
- Rate performance against expectations
- Update goals for next quarter
- Discuss development priorities

**Annual Performance Review**
- Comprehensive performance evaluation
- Promotion and compensation decisions
- Set annual goals and objectives
- Create development plan for year

### Performance Ratings

**5-Point Scale:**

| Rating | Description | % of Team Target |
|--------|-------------|------------------|
| 5 - Exceptional | Far exceeds expectations, top performer | 5-10% |
| 4 - Exceeds | Consistently exceeds expectations | 20-25% |
| 3 - Meets | Fully meets all expectations, solid performer | 50-60% |
| 2 - Partially Meets | Meets some expectations, gaps in others | 5-10% |
| 1 - Does Not Meet | Does not meet expectations | 0-5% |

### Evaluation Dimensions

#### For Solution Architects:

**1. Technical Excellence (30%)**
- Quality of architecture designs
- Depth and breadth of technical knowledge
- Application of best practices and patterns
- Ability to make sound trade-off decisions
- Innovation and creative problem solving

**2. Delivery Impact (25%)**
- Timeliness of architecture deliverables
- Success of implemented solutions
- Risk mitigation effectiveness
- Support for development teams
- Contribution to project success

**3. Communication & Collaboration (20%)**
- Clarity of documentation and presentations
- Stakeholder relationship building
- Cross-functional collaboration
- Ability to influence and build consensus
- Responsiveness and accessibility

**4. Leadership & Influence (15%)**
- Contribution to architecture standards
- Mentorship of engineers and junior architects
- Participation in community of practice
- Thought leadership
- Driving architectural improvements

**5. Strategic Thinking (10%)**
- Alignment of solutions with business goals
- Long-term thinking and technical vision
- Understanding of business context
- Proactive identification of opportunities
- Contribution to practice strategy

### Goal Setting (OKRs)

**Annual Objectives and Key Results**

Example for Solution Architect:

**Objective 1:** Drive architectural excellence for strategic initiatives

*Key Results:*
- Design and deliver architecture for 3+ high-priority projects
- Achieve average ARB approval score of 4.0+
- Zero critical production issues due to architecture gaps

**Objective 2:** Advance cloud-native architecture capabilities

*Key Results:*
- Complete AWS Solutions Architect Professional certification
- Publish 2 cloud-native reference architectures
- Lead 1 cloud migration project from design through go-live

**Objective 3:** Strengthen architecture community and standards

*Key Results:*
- Create and deliver 3 architecture training sessions
- Contribute 5+ ADRs to knowledge base
- Mentor 2 engineers interested in architecture

### Feedback & Coaching

**Effective Feedback Principles:**
- **Timely:** Provide feedback close to the event
- **Specific:** Use concrete examples and situations
- **Balanced:** Include both strengths and growth areas
- **Actionable:** Focus on behaviors that can be changed
- **Two-way:** Encourage dialogue and self-reflection

**SBI Model (Situation-Behavior-Impact):**

Example:
- **Situation:** "In yesterday's ARB meeting..."
- **Behavior:** "...when the security concern was raised, you dismissed it quickly without exploring it..."
- **Impact:** "...which made the security architect feel unheard and caused us to miss an important risk."

**Coaching Approach:**
1. Ask questions rather than providing answers
2. Help architect discover their own solutions
3. Focus on development, not just correction
4. Create safe space for vulnerability
5. Follow up on action items

### Managing Performance Issues

**Performance Improvement Plan (PIP)**

**When to Use:**
- Consistent underperformance despite coaching
- Significant gap in critical competencies
- Behavioral issues affecting team

**PIP Structure:**
- **Duration:** 30-90 days
- **Clear Expectations:** Specific, measurable objectives
- **Support Plan:** Training, resources, frequent check-ins
- **Consequences:** Clear outcomes (success, extension, or termination)
- **Documentation:** Written plan, weekly progress notes

**PIP Process:**
1. Document performance gaps with specific examples
2. Have direct conversation about concerns
3. Create written PIP with HR involvement
4. Weekly 1:1s to review progress
5. Mid-point formal review
6. Final decision at end of period

## 🎓 Career Development

### Career Ladder

#### Level Progression

```
L3: Solution Architect
  ↓ (2-3 years)
L4: Senior Solution Architect
  ↓ (3-4 years)
L5: Principal Architect
  ↓ (optional transition)
L6: Director of Architecture

OR

L5: Principal Architect (IC track)
  ↓ (continued IC track)
L6: Distinguished Architect
  ↓ 
L7: Fellow
```

### Promotion Criteria

**To Senior Solution Architect (L4):**
- 3+ years as Solution Architect (or equivalent experience)
- Independently leads complex, multi-team projects
- Strong track record of successful deliveries
- Contributes to architecture standards and patterns
- Mentors others effectively
- Demonstrates strategic thinking
- Recognized as expert in 2+ technical domains

**To Principal Architect (L5):**
- 4+ years as Senior Solution Architect (or 10+ years experience)
- Leads enterprise-level initiatives
- Defines architecture direction for domain or organization
- Published thought leadership (blogs, talks, standards)
- Shapes and drives architecture standards
- Mentors senior architects
- Strong executive presence and influence
- Deep expertise in 3+ domains, broad knowledge across all

**Promotion Process:**
1. Self-nomination or manager nomination
2. Prepare promotion packet (achievements, impact, examples)
3. Peer review and feedback
4. Presentation to promotion committee
5. Decision and communication
6. Public recognition and announcement

### Individual Development Plans (IDP)

**Annual IDP Components:**

1. **Career Goals**
   - Short-term (1 year)
   - Medium-term (2-3 years)
   - Long-term (5+ years)

2. **Skill Development**
   - Technical skills to acquire/deepen
   - Leadership/soft skills to develop
   - Domain knowledge to build

3. **Learning Activities**
   - Courses and certifications
   - Books and self-study
   - Conferences and events
   - Projects and stretch assignments

4. **Success Measures**
   - Specific, measurable objectives
   - Timeline and milestones
   - Evidence of progress

5. **Support Needed**
   - Budget for training
   - Time allocation
   - Mentorship or coaching
   - Opportunities and experiences

**IDP Review:**
- Created/updated annually
- Reviewed quarterly in 1:1s
- Adjusted as goals evolve

### Learning & Development Programs

**Internal Programs:**
- Architecture boot camp for new architects
- Monthly architecture deep-dive sessions
- Architecture book club
- Lunch & learn presentations
- Innovation days / hackathons

**External Programs:**
- Conference attendance (1-2 per year per person)
- Online learning platforms (Pluralsight, LinkedIn Learning, Coursera)
- Professional certifications (AWS, Azure, TOGAF)
- Industry workshops and training
- Architecture community participation

**Budget Guidelines:**
- $3,000-5,000 per architect per year for development
- Includes conferences, certifications, training, books
- Additional budget for team-wide programs

## 🌟 Team Culture

### Cultural Values

1. **Continuous Learning**
   - Embrace new technologies and approaches
   - Learn from both successes and failures
   - Share knowledge generously
   - Stay current with industry trends

2. **Collaboration Over Hierarchy**
   - Best idea wins, regardless of level
   - Disagree and commit
   - Assume positive intent
   - Support each other's success

3. **Pragmatism Over Perfection**
   - Done is better than perfect
   - Context matters - no one-size-fits-all
   - Balance idealism with reality
   - Deliver value incrementally

4. **Transparency & Openness**
   - Communicate openly and honestly
   - Make work visible
   - Share challenges, not just successes
   - Welcome feedback

5. **Servant Leadership**
   - Serve the teams we support
   - Remove obstacles and enable success
   - Lead by example
   - Celebrate others' achievements

### Team Rituals

**Daily/Weekly:**
- **Team Standup** (async or brief sync)
- **Office Hours** (open Q&A time)
- **Architecture Reviews** (scheduled sessions)

**Monthly:**
- **Team Meeting** (all-hands, updates, discussions)
- **Architecture Deep Dive** (technical learning)
- **Social Activity** (team building, virtual or in-person)

**Quarterly:**
- **Team Offsite** (strategy, planning, team building)
- **Retrospective** (what's working, what's not)
- **Town Hall** (broader architecture community)

**Annually:**
- **Team Summit** (multi-day planning and alignment)
- **Innovation Showcase** (present work to company)
- **Annual Planning** (strategy and goals for next year)

### Building Psychological Safety

**Key Practices:**
- Encourage questions and challenges
- Admit when you don't know
- Share your own failures and learning
- Thank people for dissenting opinions
- Never punish honest mistakes
- Model vulnerability
- Address toxic behavior immediately

### Remote/Hybrid Team Management

**Best Practices:**
- **Over-communicate** - More is better in remote setting
- **Default to async** - Respect time zones and schedules
- **Document everything** - Written > verbal
- **Create social connection** - Virtual coffee, games, off-topics
- **Be visible** - Camera on, active participation
- **Establish norms** - Response times, working hours, meeting etiquette
- **Invest in tools** - Good collaboration platforms essential

## ⚖️ Workload Management

### Capacity Planning

**Standard Allocation Model:**

For a Solution Architect:
- **60%** - Project work (architecture design, support)
- **20%** - Architecture practice (ARB, standards, community)
- **10%** - Learning and development
- **10%** - Meetings, admin, other

**Principal Architect:**
- **40%** - Strategic initiatives and technical leadership
- **30%** - Mentorship, standards, governance
- **20%** - Architecture practice operations
- **10%** - Learning and thought leadership

### Project Assignment

**Assignment Criteria:**
- **Skill match** - Right skills for project needs
- **Development opportunity** - Stretch assignment or learning
- **Workload balance** - Equitable distribution
- **Domain knowledge** - Leverage or build domain expertise
- **Relationship continuity** - Sometimes keep same architect
- **Team preferences** - Consider personal interests

**Project Types:**
- **Strategic** - High visibility, complex, business critical
- **Standard** - Normal complexity and risk
- **Quick Assist** - Short-term, focused help
- **Support** - Ongoing maintenance or optimization

### Preventing Burnout

**Warning Signs:**
- Decline in work quality
- Cynicism or negativity
- Withdrawal from team
- Missing deadlines
- Health issues
- Explicit statements of stress

**Interventions:**
- **Reduce workload** - Reassign or defer work
- **Time off** - Encourage vacation
- **Flexible schedule** - Allow autonomy
- **Address root cause** - Fix systemic issues
- **Professional help** - EAP resources
- **Check-in frequently** - Show you care

## 🎯 Retention Strategies

### Why Architects Leave

**Top Reasons:**
1. Limited growth opportunities
2. Lack of challenging work
3. Better compensation elsewhere
4. Poor management or culture
5. Work-life balance issues
6. Desire for different environment (startup vs. enterprise)

### Retention Best Practices

**Career Development:**
- Clear career path and progression
- Regular promotion opportunities
- Diverse project experiences
- Leadership opportunities
- Skill development support

**Compensation:**
- Market-competitive pay
- Regular compensation reviews
- Transparent compensation philosophy
- Meaningful bonuses and equity
- Recognition beyond money

**Culture & Environment:**
- Positive, collaborative culture
- Work-life balance and flexibility
- Psychological safety
- Autonomy and trust
- Recognition and appreciation

**Impact & Purpose:**
- Work on meaningful projects
- Visible impact on business
- Strategic influence
- Innovation opportunities
- Sense of mission alignment

### Stay Interviews

**Regular Check-ins:**
- Conduct semi-annually
- Separate from performance reviews
- Focus on satisfaction and retention

**Key Questions:**
- What do you look forward to at work?
- What are you learning?
- What would make your job more satisfying?
- What would tempt you to leave?
- What can I do to better support you?
- What are your career goals?

**Follow Through:**
- Take notes and track themes
- Act on feedback where possible
- Circle back on commitments
- Share changes made based on input

### Exit Interviews

**When Someone Leaves:**
- Conduct exit interview (ideally neutral party)
- Understand real reasons for leaving
- Identify improvement opportunities
- Leave door open for boomerang
- Maintain relationship

**Key Questions:**
- What led to your decision to leave?
- What could we have done differently?
- What did you enjoy about working here?
- What was frustrating?
- How was your relationship with your manager?
- Would you recommend others to work here?

---

**Last Updated:** November 2025  
**Owner:** Director of Architecture  
**Review Frequency:** Quarterly
