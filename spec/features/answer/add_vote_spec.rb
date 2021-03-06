require 'rails_helper'

feature 'Authenticated user can add vote to the answer' do
  given(:user) { create :user }
  given(:answer) { create :answer }
  given(:user_answer) { create :answer, author: user }
  given(:other_answer) { create :answer, question: answer.question }

  describe 'Authenticated user', js: true do
    background { sign_in(user) }

    describe 'votes for another user answer' do
      background do
        visit question_path(answer.question)
      end

      describe 'as like' do
        scenario 'and view string you like it instead vote links' do
          within "#answer-#{answer.id}" do
            expect(page).to have_link 'Like'
            expect(page).to have_link 'Dislike'
            click_on 'Like'
            expect(page).to have_no_link 'Like'
            expect(page).to have_no_link 'Dislike'
            expect(page).to have_content 'You like it!'
          end
        end

        scenario 'and do not view string you like it for other answers of question' do
          visit question_path(other_answer.question)

          within "#answer-#{answer.id}" do
            expect(page).to have_link 'Like'
            expect(page).to have_link 'Dislike'
            click_on 'Like'
          end

          within "#answer-#{other_answer.id}" do
            expect(page).to have_link 'Like'
            expect(page).to have_link 'Dislike'
            expect(page).to have_no_content 'You like it!'
          end
        end

        scenario 'and view the rating change' do
          within "#answer-#{answer.id}" do
            expect(page).to have_content 'Rating: 0'
            click_on 'Like'
            expect(page).to have_content 'Rating: 1'
          end
        end
      end

      describe 'as dislike' do
        scenario 'and view string you dislike it instead vote links' do
          within "#answer-#{answer.id}" do
            expect(page).to have_link 'Like'
            expect(page).to have_link 'Dislike'
            click_on 'Dislike'
            expect(page).to have_no_link 'Like'
            expect(page).to have_no_link 'Dislike'
            expect(page).to have_content 'You dislike it!'
          end
        end

        scenario 'and view the rating change' do
          within "#answer-#{answer.id}" do
            expect(page).to have_content 'Rating: 0'
            click_on 'Dislike'
            expect(page).to have_content 'Rating: -1'
          end
        end
      end
    end

    describe 'when tries to vote for his answer' do
      background { visit question_path(user_answer.question) }

      scenario 'doesnt view any like or dislike links' do
        within "#answer-#{user_answer.id}" do
          expect(page).to have_no_link 'Like'
          expect(page).to have_no_link 'Dislike'
        end
      end
    end
  end

  describe 'Unauthenticated user', js: true do
    background { visit question_path(answer.question) }

    scenario 'doesn`t view any like or dislike links' do
      within "#answer-#{answer.id}" do
        expect(page).to have_no_link 'Like'
        expect(page).to have_no_link 'Dislike'
      end
    end
  end
end
