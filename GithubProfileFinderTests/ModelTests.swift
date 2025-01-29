//
//  ModelTests.swift
//  GithubProfileFinderTests
//
//  Created by Diego Monteagudo Diaz on 28/01/25.
//

@testable import GithubProfileFinder
import XCTest
import SwiftData

@MainActor
class ModelTests: XCTestCase {

    var model: Model?
    var container: ModelContainer!

    override func setUpWithError() throws {
        let config = ModelConfiguration(isStoredInMemoryOnly: false)
        container = try ModelContainer(for: RecentGithubProfile.self, configurations: config)
        self.model = Model(services: GitHubProfileFinderMockServices(), modelContext: container.mainContext)
    }



    func testFetchResultsSuccess() async throws {
        // Given
        let user = "DiegoM1"

        // When
        await model?.fetchResults(user)

        // Then
        XCTAssertNotNil(model?.userInfo)
        XCTAssertEqual(model?.userInfo?.login, user)
        XCTAssertEqual(model?.viewState, .success)
    }

    func testFetchResultsFailure() async throws {
        // Given
        let searchedUser = ""

        // When
        await model?.fetchResults(searchedUser)

        // Then
        XCTAssertNil(model?.userInfo)
        XCTAssertEqual(model?.viewState, .error)
    }

    func testFetchRepositorySuccess() async throws {
        // Given
        await model?.fetchResults("DiegoM1")

        // When
        await model?.fetchRepositories()

        // Then
        XCTAssertNotNil(model?.repositoriesInfo)
        XCTAssertEqual(model?.repositoriesInfo?.count, 21)
    }

    func testFetchRepositoryFailure() async throws {
        // Given
        await model?.fetchResults("")

        // When
        await model?.fetchRepositories()

        // Then
        XCTAssertNil(model?.repositoriesInfo)
    }

    func testAddRecentProfileSuccess() async throws {

        // Given
        let userName: String = "DiegoM1"
        await model?.fetchResults(userName)
        // When
        await model?.fetchRepositories()

        // Then
        let fetchDescriptor = FetchDescriptor<RecentGithubProfile>()
        let data = try? model?.modelContext?.fetch(fetchDescriptor)
        XCTAssertNotNil(data)
        XCTAssertTrue(data!.count > 0)
    }

}
